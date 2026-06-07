CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_marts.dim_location` AS

SELECT
    SAFE_CAST(LocationID AS INT64) AS location_id,
    COALESCE(NULLIF(TRIM(Borough), ''), 'Unknown') AS borough,
    COALESCE(NULLIF(TRIM(Zone), ''), 'Unknown') AS zone,
    COALESCE(NULLIF(TRIM(servize_zone), ''), 'Unknown') AS servize_zone,
    CONCAT(
        COALESCE(NULLIF(TRIM(Borough), ''), 'Unknown'),
        ' - ',
        COALESCE(NULLIF(TRIM(Zone), ''), 'Unknown')
    ) AS full_location_name
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
WHERE location_id IS NOT NULL;