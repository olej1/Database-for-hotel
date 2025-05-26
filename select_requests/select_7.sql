-- запрос вычисляет среднюю стоимость бронирования для каждого типа номера
SELECT r.room_type, AVG(b.total_price) AS avg_booking_price
FROM htl.Rooms AS r
JOIN htl.Bookings AS b ON r.room_number = b.room_number
GROUP BY r.room_type
ORDER BY avg_booking_price DESC;