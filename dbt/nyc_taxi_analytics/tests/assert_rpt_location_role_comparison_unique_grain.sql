SELECT
    location_id,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_location_role_comparison') }}
GROUP BY location_id
HAVING COUNT(*) > 1