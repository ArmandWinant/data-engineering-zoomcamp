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
SELECT
	z.zone,
	SUM(total_amount) AS total_amount
FROM green_taxi_data t
JOIN taxi_zones_lookup z
ON z.location_id = t.pickup_location_id
WHERE date_part('day', lpep_pickup_datetime) = 18
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- QUESTION 6 - Largest Trip
SELECT
	do_z.zone,
	MAX(tip_amount) AS max_tip
FROM green_taxi_data t
JOIN taxi_zones_lookup pu_z
ON pu_z.location_id = t.pickup_location_id
JOIN taxi_zones_lookup do_z
ON do_z.location_id = t.dropoff_location_id
WHERE pu_z.zone = 'East Harlem North'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;