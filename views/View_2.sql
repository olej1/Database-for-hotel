--Представление, которое выводит бронирования, отсортированные по дате заезда и с дополнительной информацией о клиенте.

CREATE VIEW htl.booking_date_info AS
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    g.first_name, 
    g.last_name,
    r.room_type
FROM htl.Bookings AS b
JOIN htl.Guests AS g ON b.guest_id = g.guest_id
JOIN htl.Rooms AS r ON b.room_number = r.room_number
ORDER BY b.check_in_date;

select * from htl.booking_date_info