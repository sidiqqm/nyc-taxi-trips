SELECT
    pickup_location_id,
    dropoff_location_id,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_route_performance') }}
GROUP BY
    pickup_location_id,
    dropoff_location_id
HAVING COUNT(*) > 1