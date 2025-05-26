-- запрос теперь выводит имя и фамилию сотрудников, которые предоставляют услуги с ценой выше 50
SELECT s.first_name, s.last_name, se.service_name
FROM htl.Staff AS s
JOIN htl.Staff_Services AS ss ON s.staff_id = ss.staff_id
JOIN htl.Services AS se ON ss.service_id = se.service_id
WHERE se.is_active = TRUE AND se.price > 50;