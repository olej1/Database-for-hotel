--Представление, которое выводит количество заказанных услуг и их общую стоимость для оценки популярности.

CREATE VIEW htl.popular_services AS
SELECT 
    se.service_name,
    COUNT(bs.booked_service_id) AS total_bookings,
    SUM(bs.quantity * se.price) AS total_revenue
FROM htl.Booked_Services AS bs
JOIN htl.Services AS se ON bs.service_id = se.service_id
GROUP BY se.service_name
ORDER BY total_revenue DESC;

select * from htl.popular_services



WITH RECURSIVE fibonacci(val1, val2, step) AS (
    VALUES(1, 1, 1)
      UNION ALL
    SELECT val2, val1 + val2, step + 1 FROM fibonacci
    WHERE step < 30
)
SELECT val1, step FROM fibonacci;
