WITH cleaned_trips AS (
    SELECT
        trip_id,
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