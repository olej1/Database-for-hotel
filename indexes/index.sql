-- Ускоряет фильтрацию и JOIN по бронированиям
CREATE INDEX idx_booked_services_booking 
  ON htl.Booked_Services (booking_id);

-- Ускоряет поиск бронирований, связанных с определенной услугой
CREATE INDEX idx_booked_services_service 
  ON htl.Booked_Services (service_id);

-- Улучшает поиск услуг, доступных конкретному сотруднику
CREATE INDEX idx_staff_services_staff 
  ON htl.Staff_Services (staff_id);

-- Оптимизирует поиск сотрудников для определенной услуги
CREATE INDEX idx_staff_services_service 
  ON htl.Staff_Services (service_id);