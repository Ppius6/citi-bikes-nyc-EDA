/** Objective: To analyze bike ride data to understand usage patterns, peak times, popular routes, and differences in behavior between members and casual riders. **/

/** Explorary Data Analysis **/

/** Overview of the data **/
SELECT * 
FROM trips
LIMIT 10;

/** Checking for data types **/
SELECT *
FROM information_schema.columns
WHERE table_name = 'trips';

/** Converting started_at and ended_at to timestamp **/
ALTER TABLE trips
ALTER COLUMN started_at SET DATA TYPE TIMESTAMP USING started_at::TIMESTAMP,
ALTER COLUMN ended_at SET DATA TYPE TIMESTAMP USING ended_at::TIMESTAMP;

/** Confirming conversion of data types **/
SELECT *
FROM information_schema.columns
WHERE table_name = 'trips';

/** Checking for missing values for all columns **/
SELECT 
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS missing_ride_id,
    SUM(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS missing_rideable_type,
    SUM(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS missing_started_at,
    SUM(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS missing_ended_at,
    SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS missing_start_station,
    SUM(CASE WHEN start_station_id IS NULL THEN 1 ELSE 0 END) AS missing_start_station_id,
    SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS missing_end_station,
    SUM(CASE WHEN end_station_id IS NULL THEN 1 ELSE 0 END) AS missing_end_station_id,
    SUM(CASE WHEN start_lat IS NULL THEN 1 ELSE 0 END) AS missing_start_lat,
    SUM(CASE WHEN start_lng IS NULL THEN 1 ELSE 0 END) AS missing_start_lng,
    SUM(CASE WHEN end_lat IS NULL THEN 1 ELSE 0 END) AS missing_end_lat,
    SUM(CASE WHEN end_lng IS NULL THEN 1 ELSE 0 END) AS missing_end_lng,
    SUM(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS missing_member_casual
FROM trips;

/** Count of total rides **/
SELECT
    COUNT(*) AS total_rides
FROM trips;


/** Count of distinct rides by ride_id **/
SELECT
    COUNT(DISTINCT ride_id) AS distinct_rides
FROM trips;

/** Count of rides by rideable type ordered by count **/
SELECT
    rideable_type,
    COUNT(*) AS rideable_type_count
FROM trips
GROUP BY rideable_type
ORDER BY rideable_type_count DESC;

/** Count of rides by member_casual ordered by count **/
SELECT 
    member_casual,
    COUNT(*) AS member_type_counts
FROM trips
GROUP BY member_casual
ORDER BY member_type_counts DESC;

/** Count of rides by start station name ordered by count **/
SELECT
    start_station_name,
    COUNT(*) AS start_station_ride_count
FROM trips
GROUP BY start_station_name
ORDER BY start_station_ride_count DESC
LIMIT 10;

/** Count of rides by end station name ordered by count **/
SELECT
    end_station_name,
    COUNT(*) AS end_station_ride_count
FROM trips
GROUP BY end_station_name
ORDER BY end_station_ride_count DESC
LIMIT 10;

/** Finding ride counts per year **/
SELECT
    EXTRACT(YEAR FROM started_at) AS ride_year,
    COUNT(*) AS ride_count
FROM trips
GROUP BY ride_year
ORDER BY ride_year;

/** Finding ride counts per month **/
SELECT
    EXTRACT(MONTH FROM started_at) as ride_month,
    COUNT(*) AS monthly rides
FROM trips
GROUP BY ride_month
ORDER BY ride_month;

/** Finding ride counts per day of the week **/
SELECT
    EXTRACT(DOW FROM started_at) AS day_of_week,
    COUNT(*) AS weekly_rides
FROM trips
GROUP BY day_of_week
ORDER BY day_of_week;

/** Finding ride counts per hour of the day **/
SELECT
    EXTRACT(HOUR FROM started_at) AS hour_of_day,
    COUNT(*) AS hourly_rides
FROM trips
GROUP BY hour_of_day
ORDER BY hour_of_day;

/** Finding ride counts per year and member type **/
SELECT
    EXTRACT(YEAR FROM started_at) AS ride_year,
    member_casual,
    COUNT(*) AS yearly_rides
FROM trips
GROUP BY ride_year, member_casual
ORDER BY ride_year, member_casual;

/** Finding ride counts per month and member type **/
SELECT
    EXTRACT(MONTH FROM started_at) AS ride_month,
    member_casual,
    COUNT(*) AS monthly_rides
FROM trips
GROUP BY ride_month, member_casual
ORDER BY ride_month, member_casual;

/** Finding ride counts per day of the week and member type **/
SELECT
    EXTRACT(DOW FROM started_at) AS day_of_week,
    member_casual,
    COUNT(*) AS weekly_rides
FROM trips
GROUP BY day_of_week, member_casual
ORDER BY day_of_week, member_casual;

/** Finding ride counts per hour of the day and member type **/
SELECT
    EXTRACT(HOUR FROM started_at) AS hour_of_day,
    member_casual,
    COUNT(*) AS hourly_rides
FROM trips
GROUP BY hour_of_day, member_casual
ORDER BY hour_of_day, member_casual;

/** Finding ride counts per year and rideable type **/
SELECT
    EXTRACT(YEAR FROM started_at) AS ride_year,
    rideable_type,
    COUNT(*) AS yearly_rides
FROM trips
GROUP BY ride_year, rideable_type
ORDER BY ride_year, rideable_type;

/** Finding ride counts per month and rideable type **/
SELECT
    EXTRACT(MONTH FROM started_at) AS ride_month,
    rideable_type,
    COUNT(*) AS monthly_rides
FROM trips
GROUP BY ride_month, rideable_type
ORDER BY ride_month, rideable_type;

/** Finding ride counts per day of the week and rideable type **/
SELECT
    EXTRACT(DOW FROM started_at) AS day_of_ride,
    rideable_type,
    COUNT(*) AS daily_rides
FROM trips
GROUP BY day_of_ride, rideable_type
ORDER BY day_of_ride, rideable_type;

/** Finding ride counts per hour of the day and rideable type **/
SELECT
    EXTRACT(HOUR FROM started_at) AS hour_of_ride,
    rideable_type,
    COUNT(*) AS hourly_rides
FROM trips
GROUP BY hour_of_ride, rideable_type
ORDER BY hour_of_ride, rideable_type;

/** Finding ride counts per year and start station **/
SELECT
    EXTRACT(YEAR FROM started_at) AS year_of_ride,
    start_station_name,
    COUNT(*) AS yearly_rides
FROM trips
GROUP BY year_of_ride, start_station_name
ORDER BY year_of_ride, start_station_name

/** Finding ride counts per month and start station **/

/** Finding ride counts per day of the week and start station **/

/** Finding ride counts per hour of the day and start station **/

/** Finding ride counts per year and start station - using CTEs **/
WITH yearly_counts AS (
    SELECT
        EXTRACT(YEAR FROM started_at) AS year_of_ride,
        start_station_name,
        COUNT(*) AS yearly_rides
    FROM trips
    GROUP BY year_of_ride, start_station_name
)

SELECT
    year_of_ride,
    start_station_name,
    yearly_rides

FROM (
    SELECT
        year_of_ride,
        start_station_name,
        yearly_rides,
        ROW_NUMBER() OVER (PARTITION BY year_of_ride
        ORDER BY yearly_rides DESC) AS row_num
    FROM yearly_counts
) ranked_yearly_counts

WHERE row_num <= 10
ORDER BY year_of_ride, row_num;