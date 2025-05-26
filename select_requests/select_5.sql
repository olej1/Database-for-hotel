-- запрос выводит имя и фамилию гостя, статус оплаты и сумму бронирования для всех бронирований с оплатой "Paid" или "Refunded".
SELECT g.first_name, g.last_name, b.payment_status, b.total_price
FROM htl.Bookings AS b
JOIN htl.Guests AS g ON b.guest_id = g.guest_id
WHERE b.payment_status IN ('Paid', 'Refunded');