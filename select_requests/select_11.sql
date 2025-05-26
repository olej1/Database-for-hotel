-- запрос выдает список гостей, которые потратили больше 332 денег в сумме на бронирования
SELECT 
    b.guest_id, 
    g.first_name, 
    g.last_name, 
    SUM(b.total_price) AS total_spent
FROM htl.Bookings AS b
JOIN htl.Guests AS g ON b.guest_id = g.guest_id
GROUP BY b.guest_id, g.first_name, g.last_name
HAVING SUM(b.total_price) > 332
ORDER BY total_spent DESC;