-- ============================================
-- SCRIPT 5: CREATE_BUSINESS_LOGIC_PACKAGE.sql
--️ MUST RUN AS CRS_ADMIN ️
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Verify you're connected as CRS_ADMIN
SHOW USER;

-- Drop existing package
BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE CRS_BOOKING_PKG';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================
-- PACKAGE SPECIFICATION
-- ============================================
CREATE OR REPLACE PACKAGE CRS_BOOKING_PKG AS

    PROCEDURE register_passenger(
        p_first_name IN VARCHAR2,
        p_middle_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_dob IN DATE,
        p_address_line1 IN VARCHAR2,
        p_address_city IN VARCHAR2,
        p_address_state IN VARCHAR2,
        p_address_zip IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone IN VARCHAR2,
        p_passenger_id OUT NUMBER,
        p_status OUT VARCHAR2
    );
    
    PROCEDURE book_ticket(
        p_passenger_id IN NUMBER,
        p_train_id IN NUMBER,
        p_travel_date IN DATE,
        p_seat_class IN VARCHAR2,
        p_booking_id OUT NUMBER,
        p_status OUT VARCHAR2,
        p_seat_status OUT VARCHAR2,
        p_waitlist_position OUT NUMBER
    );
    
    PROCEDURE cancel_ticket(
        p_booking_id IN NUMBER,
        p_status OUT VARCHAR2
    );
    
    FUNCTION get_booking_details(p_booking_id IN NUMBER) 
        RETURN SYS_REFCURSOR;
    
    FUNCTION get_passenger_bookings(p_passenger_id IN NUMBER) 
        RETURN SYS_REFCURSOR;
    
    PROCEDURE view_train_schedule(
        p_train_number IN VARCHAR2,
        p_result OUT SYS_REFCURSOR
    );
    
    FUNCTION check_seat_availability(
        p_train_id IN NUMBER,
        p_travel_date IN DATE,
        p_seat_class IN VARCHAR2
    ) RETURN VARCHAR2;
    
END CRS_BOOKING_PKG;
/
PROMPT 'Package specification created';

-- ============================================
-- PACKAGE BODY
-- ============================================
CREATE OR REPLACE PACKAGE BODY CRS_BOOKING_PKG AS


END CRS_BOOKING_PKG;
/
