{{ config(materialized='table') }}

WITH monthly_base AS (
    SELECT
        pickup_year_month,

        COUNT(trip_id) AS total_trips,

        SUM(COALESCE(total_amount, 0)) AS gross_trip_amount,
        SUM(COALESCE(fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(tip_amount, 0)) AS total_tip_amount,
        SUM(COALESCE(tolls_amount, 0)) AS total_tolls_amount,
        SUM(COALESCE(extra, 0)) AS total_extra_amount,
        SUM(COALESCE(mta_tax, 0)) AS total_mta_tax_amount,
        SUM(COALESCE(improvement_surcharge, 0)) AS total_improvement_surcharge_amount,
        SUM(COALESCE(congestion_surcharge, 0)) AS total_congestion_surcharge_amount,
        SUM(COALESCE(airport_fee, 0)) AS total_airport_fee_amount,

        AVG(total_amount) AS avg_gross_trip_amount,
        AVG(fare_amount) AS avg_fare_amount,
        AVG(tip_amount) AS avg_tip_amount,
        AVG(trip_distance) AS avg_trip_distance,
        AVG(trip_duration_minutes) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }}
    GROUP BY pickup_year_month
),

monthly_derived AS (
    SELECT
        pickup_year_month,
        total_trips,

        gross_trip_amount,
        core_fare_amount,
        total_tip_amount,
        total_tolls_amount,
        total_extra_amount,
        total_mta_tax_amount,
        total_improvement_surcharge_amount,
        total_congestion_surcharge_amount,
        total_airport_fee_amount,

        avg_gross_trip_amount,
        avg_fare_amount,
        avg_tip_amount,
        avg_trip_distance,
        avg_trip_duration_minutes,

        (
            core_fare_amount
            + total_tip_amount
            + total_tolls_amount
            + total_extra_amount
            + total_mta_tax_amount
            + total_improvement_surcharge_amount
            + total_congestion_surcharge_amount
            + total_airport_fee_amount
        ) AS calculated_component_total,

        gross_trip_amount
        - (
            core_fare_amount
            + total_tip_amount
            + total_tolls_amount
            + total_extra_amount
            + total_mta_tax_amount
            + total_improvement_surcharge_amount
            + total_congestion_surcharge_amount
            + total_airport_fee_amount
        ) AS component_reconciliation_difference,

        SAFE_DIVIDE(total_tip_amount, core_fare_amount) * 100
            AS tip_rate_percentage,

        SAFE_DIVIDE(core_fare_amount, gross_trip_amount) * 100
            AS core_fare_share_percentage

    FROM monthly_base
),

monthly_with_lag AS (
    SELECT
        pickup_year_month,
        total_trips,

        gross_trip_amount,
        core_fare_amount,
        total_tip_amount,
        total_tolls_amount,
        total_extra_amount,
        total_mta_tax_amount,
        total_improvement_surcharge_amount,
        total_congestion_surcharge_amount,
        total_airport_fee_amount,

        calculated_component_total,
        component_reconciliation_difference,

        avg_gross_trip_amount,
        avg_fare_amount,
        avg_tip_amount,
        avg_trip_distance,
        avg_trip_duration_minutes,

        tip_rate_percentage,
        core_fare_share_percentage,

        LAG(gross_trip_amount) OVER (
            ORDER BY pickup_year_month
        ) AS previous_month_gross_trip_amount,

        LAG(core_fare_amount) OVER (
            ORDER BY pickup_year_month
        ) AS previous_month_core_fare_amount

    FROM monthly_derived
)

SELECT
    pickup_year_month,
    total_trips,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(total_tip_amount, 2) AS total_tip_amount,
    ROUND(total_tolls_amount, 2) AS total_tolls_amount,
    ROUND(total_extra_amount, 2) AS total_extra_amount,
    ROUND(total_mta_tax_amount, 2) AS total_mta_tax_amount,
    ROUND(total_improvement_surcharge_amount, 2) AS total_improvement_surcharge_amount,
    ROUND(total_congestion_surcharge_amount, 2) AS total_congestion_surcharge_amount,
    ROUND(total_airport_fee_amount, 2) AS total_airport_fee_amount,

    ROUND(calculated_component_total, 2) AS calculated_component_total,
    ROUND(component_reconciliation_difference, 2)
        AS component_reconciliation_difference,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_fare_amount, 2) AS avg_fare_amount,
    ROUND(avg_tip_amount, 2) AS avg_tip_amount,
    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes,

    ROUND(tip_rate_percentage, 2) AS tip_rate_percentage,
    ROUND(core_fare_share_percentage, 2) AS core_fare_share_percentage,

    ROUND(previous_month_gross_trip_amount, 2)
        AS previous_month_gross_trip_amount,

    ROUND(
        SAFE_DIVIDE(
            gross_trip_amount - previous_month_gross_trip_amount,
            previous_month_gross_trip_amount
        ) * 100,
        2
    ) AS gross_trip_amount_mom_growth_percentage,

    ROUND(previous_month_core_fare_amount, 2)
        AS previous_month_core_fare_amount,

    ROUND(
        SAFE_DIVIDE(
            core_fare_amount - previous_month_core_fare_amount,
            previous_month_core_fare_amount
        ) * 100,
        2
    ) AS core_fare_mom_growth_percentage

FROM monthly_with_lag