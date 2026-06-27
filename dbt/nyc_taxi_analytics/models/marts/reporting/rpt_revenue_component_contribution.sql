{{ config(materialized='table') }}

WITH revenue_totals AS (
    SELECT
        SUM(COALESCE(total_amount, 0)) AS gross_trip_amount,
        SUM(COALESCE(fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(tip_amount, 0)) AS total_tip_amount,
        SUM(COALESCE(tolls_amount, 0)) AS total_tolls_amount,
        SUM(COALESCE(extra, 0)) AS total_extra_amount,
        SUM(COALESCE(mta_tax, 0)) AS total_mta_tax_amount,
        SUM(COALESCE(improvement_surcharge, 0)) AS total_improvement_surcharge_amount,
        SUM(COALESCE(congestion_surcharge, 0)) AS total_congestion_surcharge_amount,
        SUM(COALESCE(airport_fee, 0)) AS total_airport_fee_amount
    FROM {{ ref('fact_yellow_taxi_trips') }}
),

component_rows AS (
    SELECT
        'Core Fare' AS component_name,
        'Fare' AS component_group,
        core_fare_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Tip' AS component_name,
        'Gratuity' AS component_group,
        total_tip_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Tolls' AS component_name,
        'Tolls' AS component_group,
        total_tolls_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Extra' AS component_name,
        'Tax and Surcharge' AS component_group,
        total_extra_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'MTA Tax' AS component_name,
        'Tax and Surcharge' AS component_group,
        total_mta_tax_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Improvement Surcharge' AS component_name,
        'Tax and Surcharge' AS component_group,
        total_improvement_surcharge_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Congestion Surcharge' AS component_name,
        'Tax and Surcharge' AS component_group,
        total_congestion_surcharge_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals

    UNION ALL

    SELECT
        'Airport Fee' AS component_name,
        'Tax and Surcharge' AS component_group,
        total_airport_fee_amount AS component_amount,
        gross_trip_amount
    FROM revenue_totals
)

SELECT
    component_name,
    component_group,

    ROUND(component_amount, 2) AS component_amount,
    ROUND(gross_trip_amount, 2) AS gross_trip_amount,

    ROUND(
        SAFE_DIVIDE(component_amount, gross_trip_amount) * 100,
        2
    ) AS gross_trip_amount_share_percentage,

    DENSE_RANK() OVER (
        ORDER BY component_amount DESC
    ) AS contribution_rank

FROM component_rows