-- ============================================
-- SCRIPT 10: CREATE_VIEWS.sql
-- Run as CRS_ADMIN
-- Creates reporting views for easy data access
-- ============================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Drop existing views if any
BEGIN EXECUTE IMMEDIATE 'DROP VIEW vw_passenger_bookings'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
