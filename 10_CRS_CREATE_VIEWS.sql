-- ============================================
-- SCRIPT 10: CREATE_VIEWS.sql
-- Run as CRS_ADMIN
-- Creates reporting views for easy data access
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Drop existing views if any
BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_passenger_bookings'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_active_reservations'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_train_occupancy'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_waitlist_status'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================
-- VIEW 1: Passenger Bookings (All Details)
-- Shows which passenger booked which train on which date
-- ============================================
CREATE OR REPLACE VIEW vw_passenger_bookings AS
SELECT 
    r.booking_id,
    r.booking_date,
    r.travel_date,
    p.passenger_id,
    p.first_name || ' ' || INITCAP(NVL(p.middle_name || ' ', '')) || p.last_name AS passenger_name,
    p.email,
    p.phone,
    CASE 
        WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, p.date_of_birth) / 12) < 18 THEN 'MINOR'
        WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, p.date_of_birth) / 12) >= 60 THEN 'SENIOR CITIZEN'
        ELSE 'MAJOR (ADULT)'
    END AS passenger_category,
    t.train_id,
    t.train_number,
    t.source_station,
    t.dest_station,
    r.seat_class,
    CASE r.seat_class
        WHEN 'BUSINESS' THEN t.fc_seat_fare
        ELSE t.econ_seat_fare
    END AS fare_amount,
    r.seat_status,
    r.waitlist_position
FROM CRS_RESERVATION r
JOIN CRS_PASSENGER p ON r.passenger_id = p.passenger_id
JOIN CRS_TRAIN_INFO t ON r.train_id = t.train_id;

PROMPT 'View created: vw_passenger_bookings';

-- ============================================
-- VIEW 2: Active Reservations Only
-- Shows only CONFIRMED and WAITLISTED bookings
-- ============================================
CREATE OR REPLACE VIEW vw_active_reservations AS
SELECT 
    booking_id,
    passenger_id,
    passenger_name,
    email,
    train_number,
    source_station || ' → ' || dest_station AS route,
    travel_date,
    seat_class,
    fare_amount,
    seat_status,
    waitlist_position
FROM vw_passenger_bookings
WHERE seat_status IN ('CONFIRMED', 'WAITLISTED')
ORDER BY travel_date, train_number, seat_status, waitlist_position;

PROMPT 'View created: vw_active_reservations';

-- ============================================
-- VIEW 3: Train Occupancy Summary
-- Shows seat utilization by train, date, and class
-- ============================================
CREATE OR REPLACE VIEW vw_train_occupancy AS
SELECT 
    t.train_id,
    t.train_number,
    t.source_station || ' → ' || t.dest_station AS route,
    r.travel_date,
    r.seat_class,
    CASE r.seat_class
        WHEN 'BUSINESS' THEN t.total_fc_seats
        ELSE t.total_econ_seats
    END AS total_capacity,
    COUNT(CASE WHEN r.seat_status = 'CONFIRMED' THEN 1 END) AS confirmed,
    COUNT(CASE WHEN r.seat_status = 'WAITLISTED' THEN 1 END) AS waitlisted,
    COUNT(CASE WHEN r.seat_status = 'CANCELLED' THEN 1 END) AS cancelled,
    CASE r.seat_class
        WHEN 'BUSINESS' THEN t.total_fc_seats
        ELSE t.total_econ_seats
    END - COUNT(CASE WHEN r.seat_status = 'CONFIRMED' THEN 1 END) AS available,
    ROUND(
        (COUNT(CASE WHEN r.seat_status = 'CONFIRMED' THEN 1 END) / 
         CASE r.seat_class WHEN 'BUSINESS' THEN t.total_fc_seats ELSE t.total_econ_seats END) * 100, 
        2
    ) AS occupancy_percent
FROM CRS_TRAIN_INFO t
LEFT JOIN CRS_RESERVATION r ON t.train_id = r.train_id
WHERE r.travel_date IS NOT NULL
GROUP BY t.train_id, t.train_number, t.source_station, t.dest_station, 
         r.travel_date, r.seat_class, t.total_fc_seats, t.total_econ_seats
ORDER BY r.travel_date, t.train_number, r.seat_class;

PROMPT 'View created: vw_train_occupancy';

-- ============================================
-- VIEW 4: Waitlist Status
-- Shows all waitlisted passengers
-- ============================================
CREATE OR REPLACE VIEW vw_waitlist_status AS
SELECT 
    booking_id,
    passenger_name,
    email,
    phone,
    train_number,
    source_station || ' → ' || dest_station AS route,
    travel_date,
    seat_class,
    waitlist_position,
    booking_date,
    TRUNC(travel_date - SYSDATE) AS days_until_travel
FROM vw_passenger_bookings
WHERE seat_status = 'WAITLISTED'
ORDER BY travel_date, train_number, seat_class, waitlist_position;

PROMPT 'View created: vw_waitlist_status';

-- ============================================
-- Grant SELECT on views to CRS_OPERATOR
-- ============================================
GRANT SELECT ON vw_passenger_bookings TO CRS_OPERATOR;
GRANT SELECT ON vw_active_reservations TO CRS_OPERATOR;
GRANT SELECT ON vw_train_occupancy TO CRS_OPERATOR;
GRANT SELECT ON vw_waitlist_status TO CRS_OPERATOR;
