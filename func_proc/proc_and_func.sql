-- Процедура для добавления нового гостя в таблицу Guests
CREATE OR REPLACE PROCEDURE htl.add_guest(
    p_guest_id INTEGER,
    p_first_name VARCHAR(100),
    p_last_name VARCHAR(100),
    p_email VARCHAR(100),
    p_phone VARCHAR(20),
    p_passport_number VARCHAR(50),
    p_birth_date DATE
) AS $$
BEGIN
    INSERT INTO htl.Guests (guest_id, first_name, last_name, email, phone, passport_number, birth_date)
    VALUES (p_guest_id, p_first_name, p_last_name, p_email, p_phone, p_passport_number, p_birth_date);
END;
$$ LANGUAGE plpgsql;



-- Функция для подсчёта бронирований по типу номера
CREATE OR REPLACE FUNCTION htl.count_bookings_by_room_type(p_room_type VARCHAR(50)) 
RETURNS INTEGER AS $$
DECLARE 
    total_bookings INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_bookings 
    FROM htl.Bookings b 
    JOIN htl.Rooms r ON b.room_number = r.room_number 
    WHERE r.room_type = p_room_type;
    
    RETURN total_bookings;
END;
$$ LANGUAGE plpgsql;



-- Функция для получения количества сотрудников, обслуживающих указанную активную услугу
CREATE OR REPLACE FUNCTION htl.get_staff_count_by_service(
    p_service_name VARCHAR(100)
) RETURNS INTEGER AS $$
DECLARE
    staff_count INTEGER;
BEGIN
    SELECT COUNT(ss.staff_id) INTO staff_count
    FROM htl.Services s
    JOIN htl.Staff_Services ss 
        ON s.service_id = ss.service_id
        AND ss.is_active = TRUE
    WHERE s.service_name = p_service_name
    AND s.is_active = TRUE;

    RETURN COALESCE(staff_count, 0);
END;
$$ LANGUAGE plpgsql;
