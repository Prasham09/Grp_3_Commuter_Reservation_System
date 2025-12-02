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
    ) IS
        v_passenger_id NUMBER;
    BEGIN
        IF p_first_name IS NULL OR TRIM(p_first_name) = '' THEN
            p_status := 'ERROR: First name is required';
            RETURN;
        END IF;
        
        IF p_last_name IS NULL OR TRIM(p_last_name) = '' THEN
            p_status := 'ERROR: Last name is required';
            RETURN;
        END IF;
        
        IF p_dob IS NULL OR p_dob >= SYSDATE THEN
            p_status := 'ERROR: Valid date of birth is required (must be in the past)';
            RETURN;
        END IF;
        
        IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
            p_status := 'ERROR: Valid email address is required';
            RETURN;
        END IF;
        
        IF p_phone IS NULL OR LENGTH(TRIM(p_phone)) < 10 THEN
            p_status := 'ERROR: Valid phone number is required (minimum 10 digits)';
            RETURN;
        END IF;
        
        IF NOT CRS_VALIDATION_PKG.is_email_unique(p_email) THEN
            p_status := 'ERROR: Email address already registered in the system';
            RETURN;
        END IF;
        
        IF NOT CRS_VALIDATION_PKG.is_phone_unique(p_phone) THEN
            p_status := 'ERROR: Phone number already registered in the system';
            RETURN;
        END IF;
        
        v_passenger_id := seq_passenger_id.NEXTVAL;
        
        INSERT INTO CRS_PASSENGER (
            passenger_id, first_name, middle_name, last_name,
            date_of_birth, address_line1, address_city, address_state,
            address_zip, email, phone
        ) VALUES (
            v_passenger_id, p_first_name, p_middle_name, p_last_name,
            p_dob, p_address_line1, p_address_city, p_address_state,
            p_address_zip, p_email, p_phone
        );
        
        COMMIT;
        
        p_passenger_id := v_passenger_id;
        p_status := 'SUCCESS: Passenger registered successfully with ID ' || v_passenger_id || 
                   ' (Category: ' || CRS_VALIDATION_PKG.get_passenger_category(p_dob) || ')';
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_status := 'ERROR: Duplicate email or phone number found';
        WHEN OTHERS THEN
            ROLLBACK;
            p_status := 'ERROR: Failed to register passenger - ' || SQLERRM;
    END register_passenger;
    
    
END CRS_BOOKING_PKG;
/
