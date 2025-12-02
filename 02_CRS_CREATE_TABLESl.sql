-- ============================================
-- SCRIPT 2: CREATE_TABLES.sql (NO INDEXES)
-- Connect as CRS_ADMIN and run this script
-- ============================================
show user;

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Drop existing tables 
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CRS_RESERVATION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CRS_TRAIN_SCHEDULE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CRS_PASSENGER CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CRS_DAY_SCHEDULE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CRS_TRAIN_INFO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Drop sequences 
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_train_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sch_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_tsch_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_passenger_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_booking_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create sequences
CREATE SEQUENCE seq_train_id START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_sch_id START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_tsch_id START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_passenger_id START WITH 1001 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_booking_id START WITH 5001 INCREMENT BY 1 NOCACHE;

-- ============================================
-- TABLE 1: CRS_TRAIN_INFO
-- ============================================
CREATE TABLE CRS_TRAIN_INFO (
    train_id NUMBER PRIMARY KEY,
    train_number VARCHAR2(20) NOT NULL UNIQUE,
    source_station VARCHAR2(100) NOT NULL,
    dest_station VARCHAR2(100) NOT NULL,
    total_fc_seats NUMBER DEFAULT 40 NOT NULL,
    total_econ_seats NUMBER DEFAULT 40 NOT NULL,
    fc_seat_fare NUMBER(10,2) NOT NULL,
    econ_seat_fare NUMBER(10,2) NOT NULL,
    CONSTRAINT chk_train_seats CHECK (total_fc_seats > 0 AND total_econ_seats > 0),
    CONSTRAINT chk_train_fare CHECK (fc_seat_fare > 0 AND econ_seat_fare > 0),
    CONSTRAINT chk_train_stations CHECK (source_station != dest_station)
);

PROMPT 'CRS_TRAIN_INFO created';

-- ============================================
-- TABLE 2: CRS_DAY_SCHEDULE
-- ============================================
CREATE TABLE CRS_DAY_SCHEDULE (
    sch_id NUMBER PRIMARY KEY,
    day_of_week VARCHAR2(10) NOT NULL UNIQUE,
    is_week_end CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT chk_day_weekend CHECK (is_week_end IN ('Y', 'N'))
);

PROMPT 'CRS_DAY_SCHEDULE created';

-- ============================================
-- TABLE 3: CRS_TRAIN_SCHEDULE
-- ============================================
CREATE TABLE CRS_TRAIN_SCHEDULE (
    tsch_id NUMBER PRIMARY KEY,
    sch_id NUMBER NOT NULL,
    train_id NUMBER NOT NULL,
    is_in_service CHAR(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT fk_tsch_schedule FOREIGN KEY (sch_id) REFERENCES CRS_DAY_SCHEDULE(sch_id),
    CONSTRAINT fk_tsch_train FOREIGN KEY (train_id) REFERENCES CRS_TRAIN_INFO(train_id),
    CONSTRAINT chk_tsch_service CHECK (is_in_service IN ('Y', 'N')),
    CONSTRAINT uk_tsch_schedule UNIQUE (sch_id, train_id)
);

PROMPT 'CRS_TRAIN_SCHEDULE created';