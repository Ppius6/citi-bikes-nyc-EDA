-- Ten questions to ask in the data
-- 1. Which is the most popular route for the bike trips per member type?

-- Step 1: Find the most popular routes
SELECT
    start_station_name,
    end_station_name,
    member_casual,
    COUNT(*) AS num_trips
FROM trips
GROUP BY start_station_name, end_station_name, member_casual
ORDER BY num_trips DESC
LIMIT 10;

-- Step 2: Combining to a CTE
WITH RoutePopularity AS (
    SELECT
        start_station_name,
        end_station_name,
        member_casual,
        COUNT(*) AS num_trips
    FROM trips
    GROUP BY start_station_name, end_station_name, member_casual
)
SELECT
    start_station_name,
    end_station_name,
    member_casual,
    num_trips
FROM RoutePopularity
WHERE num_trips = (
    SELECT MAX(num_trips)
    FROM RoutePopularity
    WHERE member_casual = RoutePopularity.member_casual
)
ORDER BY member_casual, num_trips DESC;

-- 2. What is the average ride duration for each hour of the day?

-- Step 1: Find the average ride duration for each hour of the day
SELECT
    EXTRACT(HOUR FROM started_at) AS ride_hour,
    AVG(ride_duration) AS avg_duration
FROM trips
GROUP BY ride_hour
ORDER BY avg_duration DESC;

-- Step 2: Adding a CASE WHEN to represent the hour in a more readable format
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM started_at) = 0 THEN '12 AM'
        WHEN EXTRACT(HOUR FROM started_at) < 12 THEN CONCAT(EXTRACT(HOUR FROM started_at), ' AM')
        WHEN EXTRACT(HOUR FROM started_at) = 12 THEN '12 PM'
        ELSE CONCAT(EXTRACT(HOUR FROM started_at) - 12, ' PM')
    END AS ride_hour,
    AVG(ride_duration) AS avg_duration
FROM trips
GROUP BY ride_hour
ORDER BY avg_duration DESC;

-- Step 3: Combining to a CTE
WITH HourlyRideDuration AS (
    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM started_at) = 0 THEN '12 AM'
            WHEN EXTRACT(HOUR FROM started_at) < 12 THEN CONCAT(EXTRACT(HOUR FROM started_at), ' AM')
            WHEN EXTRACT(HOUR FROM started_at) = 12 THEN '12 PM'
            ELSE CONCAT(EXTRACT(HOUR FROM started_at) - 12, ' PM')
        END AS ride_hour,
        AVG(ride_duration) AS avg_duration
FROM trips
GROUP BY ride_hour)

SELECT
    ride_hour,
    avg_duration AS avg_ride_duration
FROM HourlyRideDuration
ORDER BY avg_duration DESC;

-- 3. What is the monthly total distance traveled by each ride type?

-- Step 1: Find the total distance traveled by each ride type
SELECT
    EXTRACT(MONTH FROM started_at) AS ride_month,
    rideable_type,
    SUM(ride_distance) AS total_distance
FROM trips
GROUP BY ride_month, rideable_type
ORDER BY ride_month, total_distance DESC;

-- Step 2: Making the month names clear
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM started_at) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM started_at) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM started_at) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM started_at) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM started_at) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM started_at) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM started_at) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM started_at) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM started_at) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM started_at) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM started_at) = 11 THEN 'November'
        ELSE 'December'
    END AS ride_month,
    rideable_type,
    ROUND(SUM(ride_distance)::NUMERIC, 2) AS total_distance
FROM trips
GROUP BY ride_month, rideable_type
ORDER BY ride_month, total_distance DESC;

-- Step 3: Combining to a CTE

WITH MonthlyRideDistance AS (
    SELECT
    CASE
        WHEN EXTRACT(MONTH FROM started_at) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM started_at) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM started_at) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM started_at) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM started_at) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM started_at) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM started_at) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM started_at) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM started_at) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM started_at) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM started_at) = 11 THEN 'November'
        ELSE 'December'
    END AS ride_month,
    rideable_type,
    ROUND(SUM(ride_distance)::NUMERIC, 2) AS total_distance
FROM trips
GROUP BY ride_month, rideable_type)

SELECT
    ride_month,
    rideable_type,
    total_distance
FROM MONTHLYRIDEDISTANCE
ORDER BY ride_month, RIDEABLE_TYPE;

-- 4. Which are the top 5 stations with the highest average ride duration

-- 5. How is the ride distance distribution by member type?

-- 6. How is the average distance and duration for the longest rides by each ride type?

-- 7. How are the peak usage periods by member type and ride type?

-- 8. How is the Station-to-Station Traffic Flow for each member type?

-- 9. How is the Station-to-Station Traffic Flow for each rideable_type?

-- 10. What is the percentage of rides ending at the same station they started?

-- 11. How is the average ride distance for the most frequent start stations?

-- 12. What is the rank of stations by the total number of rides? 

-- 13. Which are the top 3 longest rides by each member type?

-- 14. What is the running total of rides by day?

-- 15. Which is the longest ride duration for each start station?

-- 16. Determine the Most Common Rideable Type Used for Each Start Station.

-- 17. Find rides that started and ended at the same station.

-- 18. Find the percentage change in ride counts between consecutive months.

-- 19. Identify stations with a significant increase in usage.

-- 20. Compare the average ride distance of the top 5 longest rides per day.

-- 21. Find the maximum ride duration for each day and compare it to the average ride duration.
