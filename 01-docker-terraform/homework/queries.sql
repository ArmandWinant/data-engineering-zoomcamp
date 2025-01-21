-- QUESTION 3 - Trip Segmentation Count
SELECT
	CASE
		WHEN trip_distance <= 1 THEN 'very short'
		WHEN trip_distance > 1 AND trip_distance <= 3 THEN 'short'
		WHEN trip_distance > 3 AND trip_distance <= 7 THEN 'medium'
		WHEN trip_distance > 7 AND trip_distance <= 10 THEN 'long'
		ELSE 'very long'
	END AS distance_group,
	COUNT(1) AS trip_count
FROM green_taxi_data
GROUP BY 1;

-- QUESTION 4 - Longest Trip for Each Day
SELECT
	lpep_pickup_datetime AS pickup_day,
	MAX(trip_distance) AS longest_trip
FROM green_taxi_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- QUESTION 5 - Three Biggest Pickup Zones

-- QUESTION 6 - Largest Trip