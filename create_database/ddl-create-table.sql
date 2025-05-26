
CREATE SCHEMA htl;

CREATE TABLE htl.Guests (
    guest_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    passport_number VARCHAR(50) UNIQUE,
    birth_date DATE NOT NULL
);

CREATE TABLE htl.Rooms (
    room_number INTEGER PRIMARY KEY,
    room_type VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL
);

CREATE TABLE htl.Staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL
);

CREATE TYPE bookingstatus AS ENUM (
    'Confirmed',
    'Checked-in',
    'Cancelled',
    'Checked-out'
);

CREATE TYPE paymentstatus AS ENUM (
    'Unpaid',
    'Paid',
    'Refunded'
);

CREATE TABLE htl.Bookings (
    booking_id INTEGER PRIMARY KEY,
    guest_id INTEGER,
    room_number INTEGER,
    staff_id INTEGER,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status bookingstatus NOT NULL,  
    total_price DECIMAL(10,2) NOT NULL,
    payment_status paymentstatus NOT NULL, 
    FOREIGN KEY (guest_id) REFERENCES htl.Guests(guest_id),
    FOREIGN KEY (room_number) REFERENCES htl.Rooms(room_number),
    FOREIGN KEY (staff_id) REFERENCES htl.Staff(staff_id)
);


CREATE TABLE htl.Services (
    service_id INTEGER NOT NULL,                    
    service_name VARCHAR(100) NOT NULL,             
    price DECIMAL(10,2) NOT NULL,                   
    start_date DATE NOT NULL,                       
    end_date DATE,                                  
    is_active BOOLEAN NOT NULL,                     
    PRIMARY KEY (service_id, is_active),            
    CHECK (is_active IN (TRUE, FALSE))
);

CREATE UNIQUE INDEX unique_active_service ON htl.Services (service_id)
WHERE is_active = TRUE;


CREATE TABLE htl.Booked_Services (
    booked_service_id SERIAL PRIMARY KEY,
    booking_id INTEGER,
    service_id INTEGER,
    quantity INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES htl.Bookings(booking_id),
    FOREIGN KEY (service_id, is_active) REFERENCES htl.Services(service_id, is_active)
);


CREATE TABLE htl.Staff_Services (
    staff_service_id SERIAL PRIMARY KEY,
    staff_id INTEGER,
    service_id INTEGER,
    is_active BOOLEAN NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES htl.Staff(staff_id),
    FOREIGN KEY (service_id, is_active) REFERENCES htl.Services(service_id, is_active)
);



