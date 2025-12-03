-- Run as CRS_OPERATOR 

-- 1. To See Which Passengers Booked Which Trains:
SELECT 
    passenger_name,
    train_number,
    source_station,
    dest_station,
    travel_date,
    seat_class,
    seat_status
FROM CRS_ADMIN.vw_passenger_bookings
ORDER BY travel_date, passenger_name;


-- 2. This shows only confirmed and waitlisted
SELECT * 
FROM CRS_ADMIN.vw_active_reservations
WHERE travel_date = TO_DATE('08-DEC-2025', 'DD-MON-YYYY');

-- 3. To see total capacity of each train
SELECT 
    train_number,
    route,
    travel_date,
    seat_class,
    total_capacity,
    confirmed,
    waitlisted,
    available,
    occupancy_percent || '%' AS occupancy
FROM CRS_ADMIN.vw_train_occupancy
ORDER BY travel_date, train_number;

-- 4. To see all waitlisted passengers
SELECT 
    passenger_name,
    train_number,
    travel_date,
    waitlist_position,
    days_until_travel
FROM CRS_ADMIN.vw_waitlist_status
ORDER BY travel_date, waitlist_position;