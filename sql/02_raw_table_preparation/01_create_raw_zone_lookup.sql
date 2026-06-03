CREATE OR REPLACE TABLE `nyc-taxi-trip-analytics.nyc_taxi_raw.taxi_zone_lookup` (
  LocationID INT64,
  Borough STRING,
  Zone STRING,
  service_zone STRING
)
OPTIONS (
  description = 'Raw Taxi Zone Lookup table from NYC TLC'
);