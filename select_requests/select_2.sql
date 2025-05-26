-- запрос подсчитывает количество гостей и суммарную стоимость всех бронирований для каждого статуса бронирования
SELECT status, COUNT(guest_id) AS total_guests, SUM(total_price) AS total_revenue
FROM htl.Bookings
GROUP BY status
ORDER BY total_revenue DESC;