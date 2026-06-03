-- 1. Check row count for Yellow Taxi Trips
SELECT
  COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023`;

-- 2. Check sample records
SELECT
  *
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023`
LIMIT 10;

-- 3. Check row count for Taxi Zone Lookup
SELECT
  COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`;

-- 4. Check sample Taxi Zone Lookup
SELECT
  *
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
LIMIT 10;

-- 5. Check raw date range
SELECT
  MIN(tpep_pickup_datetime) AS min_pickup_datetime,
  MAX(tpep_pickup_datetime) AS max_pickup_datetime,
  MIN(tpep_dropoff_datetime) AS min_dropoff_datetime,
  MAX(tpep_dropoff_datetime) AS max_dropoff_datetime
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023`;

-- 6. Check available columns
SELECT
  column_name,
  data_type,
  is_nullable
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'yellow_taxi_trips_2023'
ORDER BY ordinal_position;