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
WITH StationAvgDuration AS (
    SELECT
        start_station_name,
        ROUND(AVG(ride_duration)::NUMERIC, 2) AS avg_ride_duration
    FROM trips
    GROUP BY start_station_name )

SELECT
    start_station_name,
    avg_ride_duration
FROM StationAvgDuration
ORDER BY avg_ride_duration DESC
LIMIT 5;

-- 5. How is the ride distance distribution by member type?
WITH DistanceDistribution AS (
    SELECT
        member_casual,
        ride_distance,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY member_casual, ride_distance 
)

SELECT
    member_casual,
    ride_distance,
    num_rides
FROM DistanceDistribution
WHERE ride_distance > 0
GROUP BY member_casual, ride_distance, num_rides
ORDER BY member_casual, ride_distance;

-- 6. How is the average distance and duration for the longest rides by each ride type?
WITH LongestRides AS (
    SELECT
        rideable_type,
        MAX(ride_distance) AS longest_distance
    FROM trips
    GROUP BY rideable_type
)
SELECT
    t.rideable_type,
    AVG(t.ride_distance) AS avg_distance,
    AVG(t.ride_duration) AS avg_duration
FROM trips AS t
JOIN LongestRides AS l ON t.rideable_type = l.rideable_type
    AND t.ride_distance = l.longest_distance
GROUP BY t.rideable_type;

-- 7. How are the peak usage periods by hour?
WITH PeakUsage AS (
    SELECT
        EXTRACT(HOUR FROM started_at) AS ride_hour,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY ride_hour
)

SELECT
    ride_hour,
    num_rides
FROM PeakUsage
ORDER BY num_rides DESC;

-- 7b. How are the peak usage periods by hour for each member type?
WITH PeakUsage AS (
    SELECT
        EXTRACT(HOUR FROM started_at) AS ride_hour,
        member_casual AS member_type,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY ride_hour, member_type
)
SELECT
    ride_hour,
    member_type,
    num_rides
FROM PeakUsage
ORDER BY num_rides DESC;

-- 7c. How are the peak usage periods by hour for each rideable type?
WITH PeakUsage AS (
    SELECT
        EXTRACT(HOUR FROM started_at) AS ride_hour,
        rideable_type,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY ride_hour, rideable_type
)
SELECT
    ride_hour,
    rideable_type,
    num_rides
FROM PeakUsage
ORDER BY num_rides DESC;

-- 8. How is the Station-to-Station Traffic Flow for each member type?
WITH StationTrafficFlow AS (
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
FROM StationTrafficFlow
ORDER BY num_trips DESC;

-- 9. How is the Station-to-Station Traffic Flow for each rideable_type?
WITH StationTrafficFlow AS (
    SELECT
        start_station_name,
        end_station_name,
        rideable_type,
        COUNT(*) AS num_trips
    FROM trips
    GROUP BY start_station_name, end_station_name, rideable_type
)

SELECT
    start_station_name,
    end_station_name,
    rideable_type,
    num_trips
FROM StationTrafficFlow
ORDER BY num_trips DESC;

-- 10. What is the percentage of rides ending at the same station they started?
WITH SameStartStation AS (
    SELECT
        ride_id,
        CASE WHEN start_station_id = end_station_id THEN 1 ELSE 0 END AS same_station
    FROM trips
)

SELECT
    ROUND((SUM(same_station)::DECIMAL / COUNT(ride_id)) * 100, 2) AS pct_same_station
FROM SameStartStation;

-- 11. How is the average ride distance for the most frequent start stations?
WITH FrequentStartStations AS (
    SELECT
        start_station_name,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY start_station_name
    ORDER BY num_rides DESC
    LIMIT 10
)
SELECT
    t.start_station_name,
    AVG(t.ride_distance) AS avg_ride_distance
FROM trips AS t
JOIN FrequentStartStations AS f 
ON t.start_station_name = f.start_station_name
GROUP BY t.start_station_name
ORDER BY avg_ride_distance DESC;

-- 12. What is the rank of stations by the total number of rides?
WITH StationRank AS (
    SELECT
        start_station_name,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY start_station_name
)
SELECT
    start_station_name,
    num_rides,
    RANK() OVER(ORDER BY num_rides DESC) AS station_rank
FROM StationRank
ORDER BY num_rides DESC;

-- 13. Which are the top 3 longest rides by each member type?
WITH RankedRides AS (
    SELECT
        ride_id,
        member_casual,
        ride_distance,
        RANK() OVER (PARTITION BY member_casual ORDER BY ride_distance DESC) AS ride_rank    
    FROM 
        trips
    WHERE 
        ride_distance > 0
)
SELECT
    ride_id,
    member_casual,
    ride_distance,
    ride_rank
FROM RankedRides
WHERE ride_rank <= 3;

-- 14. What is the running total of rides by day of the week?
WITH DailyRideCount AS (
    SELECT
        EXTRACT(DOW FROM started_at) AS ride_day,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY ride_day
)
SELECT
    ride_day,
    num_rides,
    SUM(num_rides) OVER (ORDER BY ride_day) AS running_total,
    RANK() OVER(ORDER BY num_rides DESC) AS day_rank
FROM DailyRideCount
ORDER BY ride_day, day_rank;

-- 15. Which is the longest ride duration for each start station?
SELECT
    start_station_name,
    MAX(ride_duration) AS longest_duration
FROM trips
GROUP BY start_station_name
ORDER BY longest_duration DESC;

-- 16. Determine the Most Common Rideable Type Used for Each Start Station.
SELECT 
    start_station_name,
    rideable_type,
    COUNT(ride_id) AS ride_count
FROM
    trips t1
WHERE
    rideable_type = (
        SELECT 
            t2.rideable_type
        FROM
            trips t2
        WHERE
            t2.start_station_name = t1.start_station_name
        GROUP BY
            t2.rideable_type
        ORDER BY
            COUNT(t2.ride_id) DESC
        LIMIT 1
    )
GROUP BY
    start_station_name, rideable_type
ORDER BY
    start_station_name;

-- 17. Find rides that started and ended at the same station.
SELECT
    t1.ride_id,
    t1.start_station_id,
    t1.end_station_id
FROM trips t1
JOIN
    trips t2 ON t1.start_station_id = t2.end_station_id
WHERE
    t1.start_station_id = t2.end_station_id

-- 18. Find the percentage change in ride counts between consecutive months.
WITH MonthlyRideCounts AS (
    SELECT
        EXTRACT(MONTH FROM started_at) AS ride_month,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY ride_month
)
SELECT
    ride_month,
    num_rides,
    LAG(num_rides) OVER (ORDER BY ride_month) AS prev_month_rides,
    ROUND(((num_rides - LAG(num_rides) OVER (ORDER BY ride_month))::DECIMAL / LAG(num_rides) OVER (ORDER BY ride_month)) * 100, 2) AS pct_change
FROM MonthlyRideCounts;

-- 19. Identify stations with a significant increase in usage.
WITH StationUsage AS (
    SELECT
        start_station_name,
        EXTRACT(MONTH FROM started_at) AS ride_month,
        COUNT(*) AS num_rides
    FROM trips
    GROUP BY 
        start_station_name, ride_month
),
StationGrowth AS (
    SELECT
        start_station_name,
        ride_month,
        num_rides,
        LAG(num_rides) OVER (PARTITION BY start_station_name ORDER BY ride_month) AS prev_month_rides,
        ROUND(((num_rides - LAG(num_rides) OVER (PARTITION BY start_station_name ORDER BY ride_month))::DECIMAL / LAG(num_rides) OVER (PARTITION BY start_station_name ORDER BY ride_month)) * 100, 2) AS growth
    FROM StationUsage
)
SELECT
    start_station_name,
    ride_month,
    prev_month_rides,
    growth
FROM StationGrowth
WHERE prev_month_rides IS NOT NULL AND start_station_name IS NOT NULL
ORDER BY growth DESC
LIMIT 10;


-- 20. Compare the average ride distance of the top 5 longest rides per day.

WITH TopRidesPerDay AS (
    SELECT 
        ride_id,
        DATE(started_at) AS ride_date,
        ride_distance,
        RANK() OVER (PARTITION BY DATE(started_at) ORDER BY ride_distance DESC) AS rank
    FROM
        trips
)
SELECT 
    ride_date,
    AVG(ride_distance) AS average_top_5_distance
FROM
    TopRidesPerDay
WHERE
    rank <= 5
GROUP BY
    ride_date;

-- 21. Find the maximum ride duration for each day and compare it to the average ride duration.

WITH DailyRideDuration AS (
    SELECT
        DATE(started_at) AS ride_date,
        MAX(ride_duration) AS max_duration,
        AVG(ride_duration) AS avg_duration
    FROM trips
    GROUP BY ride_date
)
SELECT
    ride_date,
    max_duration,
    avg_duration,
    CASE
        WHEN max_duration > avg_duration THEN 'Above Average'
        WHEN max_duration < avg_duration THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS comparison
FROM DailyRideDuration
ORDER BY ride_date;

-- 22. Find the maximum ride duration for each month and compare it to the average ride duration.

WITH MonthlyRideDuration AS (
    SELECT
        EXTRACT(MONTH FROM started_at) AS ride_month,
        MAX(ride_duration) AS max_duration,
        AVG(ride_duration) AS avg_duration
    FROM trips
    GROUP BY ride_month
)
SELECT
    ride_month,
    max_duration,
    avg_duration,
    CASE
        WHEN max_duration > avg_duration THEN 'Above Average'
        WHEN max_duration < avg_duration THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS comparison
FROM MonthlyRideDuration
ORDER BY ride_month;
