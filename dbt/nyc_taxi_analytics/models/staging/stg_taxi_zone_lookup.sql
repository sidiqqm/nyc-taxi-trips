{{ config(materialized='view') }}

SELECT
    SAFE_CAST(LocationID AS INT64) AS location_id,
    COALESCE(NULLIF(TRIM(Borough), ''), 'Unknown') AS borough,
    COALESCE(NULLIF(TRIM(Zone), ''), 'Unknown') AS zone_name,
    COALESCE(NULLIF(TRIM(service_zone), ''), 'Unknown') AS service_zone,

    CONCAT(
        COALESCE(NULLIF(TRIM(Borough), ''), 'Unknown'),
        ' - ',
        COALESCE(NULLIF(TRIM(Zone), ''), 'Unknown')
    ) AS full_location_name

FROM {{ source('nyc_taxi_raw', 'taxi_zone_lookup') }}
WHERE LocationID IS NOT NULL