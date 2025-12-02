-- ============================================
-- SCRIPT 3: INSERT_SAMPLE_DATA.sql
-- Connect as CRS_ADMIN and run this script
-- ============================================
SHOW USER;


TRUNCATE TABLE CRS_RESERVATION;
TRUNCATE TABLE CRS_TRAIN_SCHEDULE;
TRUNCATE TABLE CRS_PASSENGER;
TRUNCATE TABLE CRS_TRAIN_INFO;
TRUNCATE TABLE CRS_DAY_SCHEDULE;


SET SERVEROUTPUT ON SIZE UNLIMITED;

PROMPT '========================================';
PROMPT 'Inserting Sample Data...';
PROMPT '========================================';

-- Insert Day Schedule (7 days of the week)
PROMPT 'Inserting Day Schedule...';
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'MONDAY', 'N');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'TUESDAY', 'N');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'WEDNESDAY', 'N');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'THURSDAY', 'N');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'FRIDAY', 'N');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'SATURDAY', 'Y');
INSERT INTO CRS_DAY_SCHEDULE VALUES (seq_sch_id.NEXTVAL, 'SUNDAY', 'Y');

PROMPT '7 days inserted successfully.';