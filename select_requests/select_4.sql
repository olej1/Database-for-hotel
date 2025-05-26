-- запрос рассчитывает общую стоимость всех услуг, заказанных в рамках каждого бронирования
SELECT b.booking_id, SUM(se.price * bs.quantity) AS total_service_cost
FROM htl.Bookings AS b
JOIN htl.Booked_Services AS bs ON b.booking_id = bs.booking_id
JOIN htl.Services AS se ON bs.service_id = se.service_id
GROUP BY b.booking_id
ORDER BY total_service_cost DESC;