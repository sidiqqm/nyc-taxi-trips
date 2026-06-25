{{ config(materialized='view') }}

WITH pickup_metrics AS (
    SELECT
        pickup_location_id AS location_id,
        total_trips AS pickup_trips,
        total_revenue AS pickup_revenue,
        avg_revenue_per_trip AS pickup_avg_revenue_per_trip,
        demand_rank AS pickup_demand_rank
    FROM {{ ref('rpt_pickup_location_performance') }}
),

dropoff_metrics AS (
    SELECT
        dropoff_location_id AS location_id,
        total_trips AS dropoff_trips,
        total_revenue AS dropoff_revenue,
        avg_revenue_per_trip AS dropoff_avg_revenue_per_trip,
        arrival_rank AS dropoff_arrival_rank
    FROM {{ ref('rpt_dropoff_location_performance') }}
),

combined_metrics AS (
    SELECT
        l.location_id,
        l.borough,
        l.zone_name,
        l.service_zone,
        l.full_location_name,

        COALESCE(pu.pickup_trips, 0) AS pickup_trips,
        COALESCE(do.dropoff_trips, 0) AS dropoff_trips,

        COALESCE(pu.pickup_revenue, 0) AS pickup_revenue,
        COALESCE(do.dropoff_revenue, 0) AS dropoff_revenue,

        pu.pickup_avg_revenue_per_trip,
        do.dropoff_avg_revenue_per_trip,

        pu.pickup_demand_rank,
        do.dropoff_arrival_rank

    FROM {{ ref('dim_location') }} l

    LEFT JOIN pu
        ON l.location_id = pu.location_id

    LEFT JOIN do
        ON l.location_id = do.location_id
)

SELECT
    location_id,
    borough,
    zone_name,
    service_zone,
    full_location_name,

    pickup_trips,
    dropoff_trips,

    pickup_revenue,
    dropoff_revenue,

    pickup_avg_revenue_per_trip,
    dropoff_avg_revenue_per_trip,

    pickup_demand_rank,
    dropoff_arrival_rank,

    pickup_trips - dropoff_trips AS net_pickup_minus_dropoff,

    ROUND(
        SAFE_DIVIDE(
            pickup_trips,
            NULLIF(dropoff_trips, 0)
        ),
        2
    ) AS pickup_to_dropoff_ratio,

    CASE
        WHEN pickup_trips > dropoff_trips THEN 'Net pickup origin'
        WHEN pickup_trips < dropoff_trips THEN 'Net dropoff destination'
        ELSE 'Balanced location role'
    END AS location_role

FROM combined_metrics