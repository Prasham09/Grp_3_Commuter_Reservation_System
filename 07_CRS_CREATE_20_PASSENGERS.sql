-- ============================================
-- SCRIPT:  _7__ CREATE_20_PASSENGERS.sql
-- Run as CRS_ADMIN
-- Creates 20 diverse passengers for testing
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_passenger_id NUMBER;
    v_status VARCHAR2(500);
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Creating 20 Test Passengers');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Passenger 1
    CRS_BOOKING_PKG.register_passenger(
        'James', 'Robert', 'Anderson', TO_DATE('1988-03-15', 'YYYY-MM-DD'),
        '234 Oak Street', 'Boston', 'MA', '02101',
        'james.anderson@email.com', '6171111001',
        v_passenger_id, v_status
    );
    IF v_status LIKE 'SUCCESS%' THEN v_count := v_count + 1; END IF;
    
    -- Passenger 2
    CRS_BOOKING_PKG.register_passenger(
        'Maria', 'Elena', 'Garcia', TO_DATE('1995-07-22', 'YYYY-MM-DD'),
        '567 Elm Avenue', 'Cambridge', 'MA', '02139',
        'maria.garcia@email.com', '6171111002',
        v_passenger_id, v_status
    );
    IF v_status LIKE 'SUCCESS%' THEN v_count := v_count + 1; END IF;
    
    -- Passenger 3
    CRS_BOOKING_PKG.register_passenger(
        'Robert', 'William', 'Martinez', TO_DATE('1982-11-08', 'YYYY-MM-DD'),
        '890 Pine Road', 'Somerville', 'MA', '02144',
        'robert.martinez@email.com', '6171111003',
        v_passenger_id, v_status
    );
    IF v_status LIKE 'SUCCESS%' THEN v_count := v_count + 1; END IF;
    
    -- Passenger 4
    CRS_BOOKING_PKG.register_passenger(
        'Jennifer', 'Lynn', 'Rodriguez', TO_DATE('1998-05-30', 'YYYY-MM-DD'),
        '123 Maple Drive', 'Brookline', 'MA', '02445',
        'jennifer.rodriguez@email.com', '6171111004',
        v_passenger_id, v_status
    );
    IF v_status LIKE 'SUCCESS%' THEN v_count := v_count + 1; END IF;
    
    -- Passenger 5
    CRS_BOOKING_PKG.register_passenger(
        'William', 'Charles', 'Wilson', TO_DATE('1975-09-12', 'YYYY-MM-DD'),
        '456 Cedar Lane', 'Newton', 'MA', '02458',
        'william.wilson@email.com', '6171111005',
        v_passenger_id, v_status
    );
    IF v_status LIKE 'SUCCESS%' THEN v_count := v_count + 1; END IF;
    
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Successfully created ' || v_count || ' passengers');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
END;
/

-- Verify passengers created
SELECT 
    passenger_id,
    first_name || ' ' || last_name AS full_name,
    email,
    FLOOR(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) AS age
FROM CRS_PASSENGER
WHERE passenger_id >= 1007
ORDER BY passenger_id;

PROMPT 'Passenger creation complete!';