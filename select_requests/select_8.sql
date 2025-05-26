-- запрос выдает насколько подорожали услуги по сравнению с предыдущей ценой
SELECT 
    s1.service_id,
    s1.service_name,
    s1.price AS current_price,
    s2.price AS previous_price,
    s1.price - s2.price AS price_difference
FROM htl.Services s1
JOIN htl.Services s2
    ON s1.service_id = s2.service_id
    AND s1.start_date > s2.start_date
    AND s1.is_active = TRUE
    AND s2.is_active = FALSE
ORDER BY price_difference DESC;