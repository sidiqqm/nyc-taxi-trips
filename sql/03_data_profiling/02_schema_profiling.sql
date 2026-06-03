SELECT
  table_name,
  column_name,
  data_type,
  is_nullable
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name LIKE 'yellow_taxi_trips_2023_%'
ORDER BY table_name, ordinal_position;

SELECT
  column_name,
  data_type,
  is_nullable
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'vw_yellow_taxi_trips_2023_union'
ORDER BY ordinal_position;