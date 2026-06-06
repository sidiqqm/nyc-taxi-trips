WITH cleaned_trips AS (
    SELECT
        trip_id,
        pickup_datetime,
        pickup_location_id,
        dropoff_location_id
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
),

zone_lookup AS (
    SELECT
        LocationID AS location_id
    FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
)

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(pu.location_id IS NULL) AS invalid_pickup_location_id,
    COUNTIF(doz.location_id IS NULL) AS invalid_dropoff_location_id

    FROM cleaned_trips AS trips
        LEFT JOIN zone_lookup AS pu
    ON trips.pickup_location_id = pu.location_id
        LEFT JOIN zone_lookup AS doz
    ON trips.dropoff_location_id = doz.location_id;


-- check value of null location
SELECT
    c.trip_id,
    c.pickup_datetime,
    c.pickup_location_id,
    c.dropoff_location_id,

    CASE
        WHEN pu.location_id IS NULL
            THEN TRUE
        ELSE FALSE
    END AS invalid_pickup_location_id,

    CASE
        WHEN do.location_id IS NULL
            THEN TRUE
        ELSE FALSE
    END AS invalid_dropoff_location_id

FROM cleaned_trips AS c
LEFT JOIN zone_lookup pu
    ON c.pickup_location_id = pu.location_id
LEFT JOIN zone_lookup do
    ON c.dropoff_location_id = do.location_id
WHERE pu.location_id IS NULL OR do.location_id IS NULL
LIMIT 100;