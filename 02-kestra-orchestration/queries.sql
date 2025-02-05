-- QUESTION 3
SELECT COUNT(*)
FROM de_zoomcamp_nyc_taxi.yellow_tripdata
WHERE filename LIKE '%2020%';

-- QUESTION 4
SELECT COUNT(*)
FROM de_zoomcamp_nyc_taxi.green_tripdata
WHERE filename LIKE '%2020%';

-- QUESTION 5
SELECT COUNT(*)
FROM de_zoomcamp_nyc_taxi.yellow_tripdata
WHERE filename LIKE '%03-2021%';