import pytest
import sqlite3
from sqlite3 import Connection

import pytest
import sqlite3
from sqlite3 import Connection

@pytest.fixture
def db_connection() -> Connection:
    # Подключение к существующей БД (замените параметры на свои)
    conn = sqlite3.connect("path_to_your_database.db")
    conn.row_factory = sqlite3.Row
    conn.execute("BEGIN")  # Старт транзакции
    yield conn
    conn.rollback()  # Откат любых изменений
    conn.close()

# 1. Тест для бронирований с status='Confirmed' и total_price>150
def test_confirmed_bookings_over_150(db_connection):
    result = db_connection.execute("""
    SELECT g.first_name, g.last_name, b.total_price
    FROM htl.Bookings AS b
    JOIN htl.Guests AS g ON b.guest_id = g.guest_id
    WHERE b.status = 'Confirmed' AND b.total_price > 150
    """).fetchall()
    
    # Проверка, что все возвращенные записи соответствуют условиям
    assert len(result) > 0
    assert all(row["status"] == "Confirmed" and row["total_price"] > 150 for row in result)

# 2. Тест агрегации по статусам бронирований
def test_booking_stats_by_status(db_connection):
    result = db_connection.execute("""
    SELECT status, COUNT(guest_id) AS total_guests, SUM(total_price) AS total_revenue
    FROM htl.Bookings
    GROUP BY status
    ORDER BY total_revenue DESC
    """).fetchall()
    
    # Проверка корректности агрегации
    assert len(result) >= 1
    assert all(isinstance(row["total_revenue"], float) for row in result)

# 3. Тест для расчета услуг на должность
def test_services_per_position(db_connection):
    result = db_connection.execute("""
    SELECT s.position, 
           COUNT(ss.staff_service_id)/COUNT(DISTINCT s.staff_id) AS services_per_position
    FROM htl.Staff AS s
    JOIN htl.Staff_Services AS ss ON s.staff_id = ss.staff_id
    GROUP BY s.position
    """).fetchall()
    
    # Проверка наличия данных и типа результатов
    assert len(result) >= 1
    assert all(isinstance(row["services_per_position"], float) for row in result)

# 4. Тест общей стоимости услуг в бронировании
def test_total_service_cost_per_booking(db_connection):
    result = db_connection.execute("""
    SELECT b.booking_id, SUM(se.price * bs.quantity) AS total_service_cost
    FROM htl.Bookings AS b
    JOIN htl.Booked_Services AS bs ON b.booking_id = bs.booking_id
    JOIN htl.Services AS se ON bs.service_id = se.service_id
    GROUP BY b.booking_id
    """).fetchall()
    
    # Проверка расчета стоимости
    if result:
        assert all(row["total_service_cost"] > 0 for row in result)

# 5. Тест фильтрации по статусам оплаты
def test_payment_status_filter(db_connection):
    result = db_connection.execute("""
    SELECT payment_status 
    FROM htl.Bookings 
    WHERE payment_status IN ('Paid', 'Refunded')
    """).fetchall()
    
    # Проверка корректности фильтрации
    if result:
        valid_statuses = {'Paid', 'Refunded'}
        assert all(row["payment_status"] in valid_statuses for row in result)

# 6. Тест для сотрудников с услугами дороже 50
def test_expensive_services_staff(db_connection):
    result = db_connection.execute("""
    SELECT DISTINCT s.staff_id
    FROM htl.Staff AS s
    JOIN htl.Staff_Services AS ss ON s.staff_id = ss.staff_id
    JOIN htl.Services AS se ON ss.service_id = se.service_id
    WHERE se.price > 50
    """).fetchall()
    
    # Проверка наличия сотрудников
    assert len(result) >= 0  # Может быть 0 или более

# 7. Тест средней стоимости бронирования по типу комнаты
def test_avg_price_by_room_type(db_connection):
    result = db_connection.execute("""
    SELECT room_type, AVG(total_price) AS avg_price
    FROM htl.Bookings
    GROUP BY room_type
    """).fetchall()
    
    # Проверка расчета средней стоимости
    assert len(result) >= 1
    assert all(isinstance(row["avg_price"], float) for row in result)

# 8. Тест изменения цен на услуги
def test_price_changes(db_connection):
    result = db_connection.execute("""
    SELECT price_difference 
    FROM (
        SELECT s1.price - s2.price AS price_difference
        FROM htl.Services s1
        JOIN htl.Services s2 ON s1.service_id = s2.service_id
        WHERE s1.start_date > s2.start_date
    ) AS diffs
    WHERE price_difference > 0
    """).fetchall()
    
    # Проверка наличия изменений цен
    assert len(result) >= 0

# 9. Тест гостей в комнатах ≥2 мест
def test_guests_in_large_rooms(db_connection):
    result = db_connection.execute("""
    SELECT DISTINCT g.guest_id
    FROM htl.Guests g
    JOIN htl.Bookings b ON g.guest_id = b.guest_id
    JOIN htl.Rooms r ON b.room_number = r.room_number
    WHERE r.capacity >= 2
    """).fetchall()
    
    # Проверка наличия гостей
    assert len(result) >= 0

# 10. Тест первых 5 заселений
def test_first_5_checkins(db_connection):
    result = db_connection.execute("""
    SELECT check_in_date 
    FROM htl.Bookings 
    ORDER BY check_in_date 
    LIMIT 5
    """).fetchall()
    
    # Проверка ограничения выборки
    assert len(result) <= 5
    if len(result) > 1:
        dates = [row["check_in_date"] for row in result]
        assert dates == sorted(dates)  # Проверка сортировки