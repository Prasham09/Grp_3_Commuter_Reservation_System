-- ============================================
-- SCRIPT 4: CREATE_VALIDATION_PACKAGE.sql
-- Connect as CRS_ADMIN and run this script
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE CRS_VALIDATION_PKG';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE BODY CRS_VALIDATION_PKG';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================
-- PACKAGE SPECIFICATION: CRS_VALIDATION_PKG
-- Contains all validation functions
-- ============================================
CREATE OR REPLACE PACKAGE CRS_VALIDATION_PKG AS
-- Custom Exception Declarations
    ex_invalid_train EXCEPTION;
    ex_invalid_date EXCEPTION;
    ex_invalid_passenger EXCEPTION;
    ex_invalid_class EXCEPTION;
    ex_no_seats EXCEPTION;
    ex_train_not_available EXCEPTION;
    ex_booking_date_invalid EXCEPTION;
    ex_duplicate_email EXCEPTION;
    ex_duplicate_phone EXCEPTION;
    
    -- Validation Functions
    FUNCTION is_train_valid(p_train_id IN NUMBER) RETURN BOOLEAN;
    
    FUNCTION is_passenger_valid(p_passenger_id IN NUMBER) RETURN BOOLEAN;
    
    FUNCTION is_train_available_on_date(
        p_train_id IN NUMBER,
        p_travel_date IN DATE
    ) RETURN BOOLEAN;
    
    FUNCTION is_booking_date_valid(
        p_booking_date IN DATE,
        p_travel_date IN DATE
    ) RETURN BOOLEAN;
    
    FUNCTION is_seat_class_valid(p_seat_class IN VARCHAR2) RETURN BOOLEAN;
    
    FUNCTION get_available_seats(
        p_train_id IN NUMBER,
        p_travel_date IN DATE,
        p_seat_class IN VARCHAR2
    ) RETURN NUMBER;
    
    FUNCTION get_waitlist_count(
        p_train_id IN NUMBER,
        p_travel_date IN DATE,
        p_seat_class IN VARCHAR2
    ) RETURN NUMBER;
    
    FUNCTION is_email_unique(
        p_email IN VARCHAR2,
        p_passenger_id IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN;
    
    FUNCTION is_phone_unique(
        p_phone IN VARCHAR2,
        p_passenger_id IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN;
    
    FUNCTION calculate_age(p_dob IN DATE) RETURN NUMBER;
    
    FUNCTION get_passenger_category(p_dob IN DATE) RETURN VARCHAR2;
    
    FUNCTION get_total_seats(
        p_train_id IN NUMBER,
        p_seat_class IN VARCHAR2
    ) RETURN NUMBER;
    
END CRS_VALIDATION_PKG;
/