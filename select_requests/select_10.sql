-- запрос выдает 5 людей в порядке их заселения в отель
SELECT g.first_name, g.last_name, b.check_in_date
FROM htl.Bookings AS b
JOIN htl.Guests AS g ON b.guest_id = g.guest_id
ORDER BY b.check_in_date
FETCH FIRST 5 ROWS ONLY;