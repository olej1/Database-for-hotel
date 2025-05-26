--Представление, которое показывает количество бронирований по каждому статусу оплаты ("Paid", "Unpaid", "Refunded"), а также общую сумму для каждого статуса.

CREATE VIEW htl.payment_status_summary AS
SELECT 
    payment_status,
    COUNT(booking_id) AS total_bookings,
    SUM(total_price) AS total_revenue
FROM htl.Bookings
GROUP BY payment_status;
