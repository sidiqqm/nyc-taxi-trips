SELECT
    pickup_location_id,
    payment_type_id,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_payment_pickup_location_behavior') }}
GROUP BY
    pickup_location_id,
    payment_type_id
HAVING COUNT(*) > 1