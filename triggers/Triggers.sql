-- Триггер, который запрещает добавление брони на номер, если он уже забронирован
CREATE OR REPLACE FUNCTION htl.check_room_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM htl.Bookings b
        WHERE b.room_number = NEW.room_number
        AND b.status IN ('Confirmed', 'Checked-in')
        AND NOT (NEW.check_out_date <= b.check_in_date OR NEW.check_in_date >= b.check_out_date)
        AND b.booking_id <> COALESCE(NEW.booking_id, -1)
    ) THEN
        RAISE EXCEPTION 
            'Room % is already booked',
            NEW.room_number;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_double_booking
BEFORE INSERT OR UPDATE ON htl.Bookings
FOR EACH ROW EXECUTE FUNCTION htl.check_room_availability();

--Триггер, который удаляет связи работник-сервис при удалении работника
CREATE OR REPLACE FUNCTION htl.delete_staff_services()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM htl.Staff_Services 
    WHERE staff_id = OLD.staff_id;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER staff_delete_trigger
AFTER DELETE ON htl.Staff
FOR EACH ROW
EXECUTE FUNCTION htl.delete_staff_services();

--Триггер, который запрещает бронирование лицам младше 18 лет
CREATE OR REPLACE FUNCTION htl.check_guest_age()
RETURNS TRIGGER AS $$
DECLARE
    guest_age INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(NOW(), birth_date)) 
    INTO guest_age
    FROM htl.Guests 
    WHERE guest_id = NEW.guest_id;

    IF guest_age < 18 THEN
        RAISE EXCEPTION 'Guest must be at least 18 years old';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER guest_age_trigger
BEFORE INSERT ON htl.Bookings
FOR EACH ROW EXECUTE FUNCTION htl.check_guest_age();
