CREATE OR REPLACE EXTERNAL TABLE `de_zoomcamp_nyc_taxi.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-zoomcamp-nyc-taxi-sacred-choir-454809-s9/yellow_tripdata_*.parquet']
);

CREATE OR REPLACE TABLE `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`
AS SELECT * FROM `de_zoomcamp_nyc_taxi.external_yellow_tripdata`;


-- QUESTION 1 (20332093)
SELECT COUNT(*) FROM `de_zoomcamp_nyc_taxi.external_yellow_tripdata`;

-- QUESTION 2 (B)
SELECT COUNT(DISTINCT PULocationID) FROM `de_zoomcamp_nyc_taxi.external_yellow_tripdata`; 
SELECT COUNT(DISTINCT PULocationID) FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`; 

-- QUESTION 3 (A)
SELECT PULocationID FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`;
SELECT PULocationID, DOLocationID FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`;

-- QUESTION 4 (8333)
SELECT COUNT(1) FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`
WHERE fare_amount = 0;

-- QUESTION 5 (A)

-- QUESTION 6 (310.24, 26.84)
CREATE OR REPLACE TABLE `de_zoomcamp_nyc_taxi.yellow_tripdata_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime) AS
SELECT * FROM `de_zoomcamp_nyc_taxi.external_yellow_tripdata`;

SELECT DISTINCT(VendorID) FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_non_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-15';

SELECT DISTINCT(VendorID) FROM `de_zoomcamp_nyc_taxi.yellow_tripdata_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-15';

-- QUESTION 7 (C)

-- QUESTION 8 (False)