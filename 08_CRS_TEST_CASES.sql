-- ============================================
-- SCRIPT 8: TEST_CASES.sql (FINAL)
-- ⚠️ RUN AS CRS_OPERATOR ⚠️
-- Matches your actual passengers: 1001-1026
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Verify you're connected as CRS_OPERATOR
SHOW USER;

DECLARE
    v_passenger_id NUMBER;
    v_booking_id NUMBER;
    v_status VARCHAR2(500);
    v_seat_status VARCHAR2(20);
    v_waitlist_pos NUMBER;
    v_test_count NUMBER := 0;
    v_pass_count NUMBER := 0;
    v_timestamp VARCHAR2(20) := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
    v_first_booking_id NUMBER;
    v_passenger_index NUMBER := 1;
    
    -- YOUR ACTUAL 26 passengers (NO GAPS)
    TYPE passenger_array IS VARRAY(26) OF NUMBER;
    v_passengers passenger_array := passenger_array(
        1001, 1002, 1003, 1004, 1005, 1006,
        1007, 1008, 1009, 1010, 1011, 1012,
        1013, 1014, 1015, 1016, 1017, 1018,
        1019, 1020, 1021, 1022, 1023, 1024,
        1025, 1026
    );
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('COMMUTER RESERVATION SYSTEM');
    DBMS_OUTPUT.PUT_LINE('COMPREHENSIVE TEST SUITE');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Run Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');

    -- TEST 1
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Register New Passenger - Valid Data');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.register_passenger(
        p_first_name => 'Alice',
        p_middle_name => 'Marie',
        p_last_name => 'TestUser',
        p_dob => TO_DATE('1992-06-15', 'YYYY-MM-DD'),
        p_address_line1 => '100 Test Street',
        p_address_city => 'Boston',
        p_address_state => 'MA',
        p_address_zip => '02115',
        p_email => 'alice.test.' || v_timestamp || '@email.com',
        p_phone => '617555' || SUBSTR(v_timestamp, -4),
        p_passenger_id => v_passenger_id,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'SUCCESS%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 2
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Register Passenger - Duplicate Email (Should Fail)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.register_passenger(
        p_first_name => 'Bob',
        p_middle_name => NULL,
        p_last_name => 'Wilson',
        p_dob => TO_DATE('1988-03-20', 'YYYY-MM-DD'),
        p_address_line1 => '200 Test Ave',
        p_address_city => 'Cambridge',
        p_address_state => 'MA',
        p_address_zip => '02139',
        p_email => 'alice.test.' || v_timestamp || '@email.com',
        p_phone => '617555' || SUBSTR(v_timestamp, -3) || '1',
        p_passenger_id => v_passenger_id,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'ERROR%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 3
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Register Passenger - Duplicate Phone (Should Fail)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.register_passenger(
        p_first_name => 'Charlie',
        p_middle_name => NULL,
        p_last_name => 'Brown',
        p_dob => TO_DATE('1995-08-10', 'YYYY-MM-DD'),
        p_address_line1 => '300 Test Rd',
        p_address_city => 'Boston',
        p_address_state => 'MA',
        p_address_zip => '02116',
        p_email => 'charlie.test.' || v_timestamp || '@email.com',
        p_phone => '617555' || SUBSTR(v_timestamp, -4),
        p_passenger_id => v_passenger_id,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'ERROR%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
       -- TEST 4
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Register Passenger - Invalid Email (Should Fail)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.register_passenger(
        p_first_name => 'David',
        p_middle_name => NULL,
        p_last_name => 'Green',
        p_dob => TO_DATE('1990-01-01', 'YYYY-MM-DD'),
        p_address_line1 => '400 Test Ln',
        p_address_city => 'Boston',
        p_address_state => 'MA',
        p_address_zip => '02117',
        p_email => 'invalid-email-format',
        p_phone => '617555' || SUBSTR(v_timestamp, -3) || '2',
        p_passenger_id => v_passenger_id,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'ERROR%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 5
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Book Ticket - BUSINESS Class');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.book_ticket(
        p_passenger_id => 1001,
        p_train_id => 1,
        p_travel_date => TRUNC(SYSDATE) + 3,
        p_seat_class => 'BUSINESS',
        p_booking_id => v_booking_id,
        p_status => v_status,
        p_seat_status => v_seat_status,
        p_waitlist_position => v_waitlist_pos
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'SUCCESS%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 6
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Book Ticket - ECONOMY Class');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.book_ticket(
        p_passenger_id => 1007,
        p_train_id => 1,
        p_travel_date => TRUNC(SYSDATE) + 3,
        p_seat_class => 'ECONOMY',
        p_booking_id => v_booking_id,
        p_status => v_status,
        p_seat_status => v_seat_status,
        p_waitlist_position => v_waitlist_pos
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'SUCCESS%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 7
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Book Ticket - Invalid Train (Should Fail)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.book_ticket(
        p_passenger_id => 1010,
        p_train_id => 99999,
        p_travel_date => TRUNC(SYSDATE) + 3,
        p_seat_class => 'BUSINESS',
        p_booking_id => v_booking_id,
        p_status => v_status,
        p_seat_status => v_seat_status,
        p_waitlist_position => v_waitlist_pos
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'ERROR%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- TEST 8
    v_test_count := v_test_count + 1;
    DBMS_OUTPUT.PUT_LINE('TEST ' || v_test_count || ': Book Ticket - Beyond 7 Days (Should Fail)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    CRS_ADMIN.CRS_BOOKING_PKG.book_ticket(
        p_passenger_id => 1015,
        p_train_id => 1,
        p_travel_date => TRUNC(SYSDATE) + 10,
        p_seat_class => 'ECONOMY',
        p_booking_id => v_booking_id,
        p_status => v_status,
        p_seat_status => v_seat_status,
        p_waitlist_position => v_waitlist_pos
    );
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
    IF v_status LIKE 'ERROR%' THEN v_pass_count := v_pass_count + 1; END IF;
    DBMS_OUTPUT.PUT_LINE('');
    
    -- SUMMARY
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('TEST SUITE SUMMARY');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Total Tests: ' || v_test_count);
    DBMS_OUTPUT.PUT_LINE('Tests Passed: ' || v_pass_count);
    DBMS_OUTPUT.PUT_LINE('Tests Failed: ' || (v_test_count - v_pass_count));
    DBMS_OUTPUT.PUT_LINE('Success Rate: ' || ROUND((v_pass_count / v_test_count) * 100, 2) || '%');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    IF v_pass_count = v_test_count THEN
        DBMS_OUTPUT.PUT_LINE('ALL TESTS PASSED!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('' || (v_test_count - v_pass_count) || ' TEST(S) FAILED');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    
END;
/