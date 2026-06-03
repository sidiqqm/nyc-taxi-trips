SELECT
  source_month,
  COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
GROUP BY source_month
ORDER BY source_month;