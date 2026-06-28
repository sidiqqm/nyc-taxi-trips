WITH payment_summary AS (
    SELECT
        payment_type_name,
        payment_category,
        total_trips,
        trip_share_percentage,
        gross_trip_amount,
        gross_trip_amount_share_percentage,
        avg_gross_trip_amount,
        trip_volume_rank,
        gross_trip_amount_rank
    FROM {{ ref('rpt_payment_behavior') }}
),

top_cashless_zones AS (
    SELECT
        pickup_borough,
        pickup_zone,
        payment_type_name,
        total_trips,
        payment_trip_share_within_zone,
        payment_volume_rank_within_zone
    FROM {{ ref('rpt_payment_pickup_location_behavior') }}
    WHERE LOWER(payment_type_name) = 'credit card'
)

SELECT
    'Payment Summary' AS analysis_type,
    payment_type_name AS category,
    total_trips AS primary_metric,
    gross_trip_amount AS secondary_metric,
    trip_volume_rank AS rank_metric
FROM payment_summary

UNION ALL

SELECT
    'Top Credit Card Zone' AS analysis_type,
    CONCAT(pickup_borough, ' - ', pickup_zone) AS category,
    total_trips AS primary_metric,
    payment_trip_share_within_zone AS secondary_metric,
    payment_volume_rank_within_zone AS rank_metric
FROM top_cashless_zones
WHERE payment_volume_rank_within_zone = 1