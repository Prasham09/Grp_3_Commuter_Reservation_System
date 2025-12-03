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