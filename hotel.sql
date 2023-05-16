CREATE VIEW t1 AS SELECT hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month, arrival_date_week_number, 
	   arrival_date_day_of_month, stays_in_weekend_nights, stays_in_week_nights, adults, children, babies, meal, 
       country, market_segment, distribution_channel, is_repeated_guest, previous_cancellations, 
       previous_bookings_not_canceled, reserved_room_type, assigned_room_type, deposit_type,
       COALESCE(agent,0) AS agent, COALESCE(company, 'not_recorded') AS company, days_in_waiting_list, customer_type,
       adr, required_car_parking_spaces, total_of_special_requests, reservation_status, STR_TO_DATE(CONCAT(arrival_date_year, '-' , arrival_date_month, '-', arrival_date_day_of_month), '%Y-%M-%D')  AS reservation_date
FROM (SELECT * FROM hotel.2018
UNION
SELECT * FROM hotel.2019 
UNION
SELECT * FROM hotel.2020) AS t2;

-- What is the total revenue of the hotel by hotel and year  
SELECT hotel, arrival_date_year, ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-discount)),2) as revenue
FROM t1
LEFT JOIN market_segment m ON m.market_segment = t1.market_segment
GROUP BY 1,2;

-- What is the total revenue of the hotel by  room type?
SELECT reserved_room_type, ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-discount)),2) as revenue
FROM t1
LEFT JOIN market_segment m ON m.market_segment = t1.market_segment
GROUP BY 1
ORDER BY 2 DESC;

-- What is the total revenue by month
SELECT arrival_date_month, ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-discount)),2) as revenue
FROM t1
LEFT JOIN market_segment m ON m.market_segment = t1.market_segment
GROUP BY 1;

-- What is the total revenue of the hotel by customer type and month?
SELECT customer_type,arrival_date_month, ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-discount)),2) as revenue
FROM t1
LEFT JOIN market_segment m ON m.market_segment = t1.market_segment
GROUP BY 1,2
ORDER BY 3 DESC;

-- The number of visitors of the hotel by hotel type and year
SELECT hotel, arrival_date_year, SUM( adults + children + babies) AS total_guest
FROM t1
GROUP BY 1,2;

-- The number of visitors of the hotel by month 
SELECT arrival_date_month, SUM( adults + children + babies) AS total_guest
FROM t1
GROUP BY 1
