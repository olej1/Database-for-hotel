-- запрос выводит, сколько услуг приходится на каждую должность.
SELECT s.position, 
       COUNT(ss.staff_service_id) / COUNT(DISTINCT s.staff_id) AS services_per_position
FROM htl.Staff AS s
JOIN htl.Staff_Services AS ss ON s.staff_id = ss.staff_id
GROUP BY s.position
ORDER BY services_per_position DESC;