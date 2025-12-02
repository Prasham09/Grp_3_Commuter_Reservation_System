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

-- ============================================
-- PACKAGE BODY: CRS_VALIDATION_PKG
-- Implementation of all validation functions
-- ============================================
CREATE OR REPLACE PACKAGE BODY CRS_VALIDATION_PKG AS
    
    -- ========================================
    -- FUNCTION: is_train_valid
    -- Validates if train exists in system
    -- Business Rule: Validate train number
    -- ========================================
    FUNCTION is_train_valid(p_train_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM CRS_TRAIN_INFO
        WHERE train_id = p_train_id;
        
        RETURN (v_count > 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END is_train_valid;
    
    -- ========================================
    -- FUNCTION: is_passenger_valid
    -- Validates if passenger exists in system
    -- Business Rule: Validate passenger info
    -- ========================================
    FUNCTION is_passenger_valid(p_passenger_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM CRS_PASSENGER
        WHERE passenger_id = p_passenger_id;
        
        RETURN (v_count > 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END is_passenger_valid;
    
    -- ========================================
    -- FUNCTION: is_train_available_on_date
    -- Checks if train runs on given date
    -- Business Rule: Train availability check
    -- ========================================
    FUNCTION is_train_available_on_date(
        p_train_id IN NUMBER,
        p_travel_date IN DATE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
        v_day_of_week VARCHAR2(10);
    BEGIN
        -- Get day of week for travel date
        v_day_of_week := UPPER(TO_CHAR(p_travel_date, 'DAY'));
        v_day_of_week := TRIM(v_day_of_week);
        
        -- Check if train is scheduled for that day
        SELECT COUNT(*)
        INTO v_count
        FROM CRS_TRAIN_SCHEDULE ts
        JOIN CRS_DAY_SCHEDULE ds ON ts.sch_id = ds.sch_id
        WHERE ts.train_id = p_train_id
        AND ds.day_of_week = v_day_of_week
        AND ts.is_in_service = 'Y';
        
        RETURN (v_count > 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END is_train_available_on_date;
    
    -- ========================================
    -- FUNCTION: is_booking_date_valid
    -- Validates booking is within 7 days advance
    -- Business Rule: Only one week advance booking
    -- ========================================
    FUNCTION is_booking_date_valid(
        p_booking_date IN DATE,
        p_travel_date IN DATE
    ) RETURN BOOLEAN IS
        v_days_diff NUMBER;
    BEGIN
        v_days_diff := TRUNC(p_travel_date) - TRUNC(p_booking_date);
        
        -- Must be between 0 and 7 days in advance
        RETURN (v_days_diff >= 0 AND v_days_diff <= 7);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END is_booking_date_valid;
    
END CRS_VALIDATION_PKG;
/
