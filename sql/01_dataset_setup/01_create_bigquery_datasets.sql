CREATE SCHEMA IF NOT EXISTS `nyc-taxi-trip-analytics.nyc_taxi_raw`
OPTIONS (
  location = 'US',
  description = 'Raw dataset for NYC Yellow Taxi Trip Records and Taxi Zone Lookup'
);

CREATE SCHEMA IF NOT EXISTS `nyc-taxi-trip-analytics.nyc_taxi_staging`
OPTIONS (
  location = 'US',
  description = 'Staging dataset for standardized and lightly cleaned NYC taxi data'
);

CREATE SCHEMA IF NOT EXISTS `nyc-taxi-trip-analytics.nyc_taxi_intermediate`
OPTIONS (
  location = 'US',
  description = 'Intermediate dataset for enriched taxi trip transformations'
);

CREATE SCHEMA IF NOT EXISTS `nyc-taxi-trip-analytics.nyc_taxi_marts`
OPTIONS (
  location = 'US',
  description = 'Analytics mart dataset for BI dashboard and business reporting'
);