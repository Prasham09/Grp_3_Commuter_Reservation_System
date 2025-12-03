-- ============================================
-- SCRIPT 10: CREATE_VIEWS.sql
-- Run as CRS_ADMIN
-- Creates reporting views for easy data access
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Drop existing views if any
BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_passenger_bookings'; EXCEPTION WHEN OTHERS THEN NULL; END;
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



