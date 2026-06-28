SELECT
    pickup_time_period,
    payment_type_id,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_payment_time_behavior') }}
GROUP BY
    pickup_time_period,
    payment_type_id
HAVING COUNT(*) > 1