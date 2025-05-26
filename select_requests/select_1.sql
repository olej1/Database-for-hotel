-- запрос выводит имя гостя и стоимость бронирования для всех бронирований, где статус "Confirmed" и сумма бронирования больше 150
SELECT g.first_name, g.last_name, b.total_price
FROM htl.Bookings AS b
JOIN htl.Guests AS g ON b.guest_id = g.guest_id
WHERE b.status = 'Confirmed' AND b.total_price > 150;
