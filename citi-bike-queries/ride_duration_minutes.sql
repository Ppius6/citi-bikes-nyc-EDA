ALTER TABLE trips
ADD COLUMN ride_duration_minutes NUMERIC;

UPDATE trips
SET ride_duration_minutes = 
	CASE 
		WHEN ended_at::timestamp without time zone < started_at THEN ROUND(EXTRACT(EPOCH FROM (ended_at::timestamp without time zone + INTERVAL '1 day' - started_at)) / 60, 2)
	ELSE
		ROUND(EXTRACT(EPOCH FROM (ended_at::timestamp without time zone - started_at)) / 60, 2)
END;	
		