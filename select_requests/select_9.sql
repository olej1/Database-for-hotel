-- запрос выдает список гостей, забронировавших средние и большие номера
SELECT g.first_name, g.last_name, b.booking_id, r.room_type
FROM htl.Guests AS g
JOIN htl.Bookings AS b ON g.guest_id = b.guest_id
JOIN htl.Rooms AS r ON b.room_number = r.room_number
WHERE r.capacity >= 2;