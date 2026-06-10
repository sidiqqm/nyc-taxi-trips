{{ config(materialized='table') }}

SELECT
    rate_code_id,
    rate_code_name,
    rate_category,
    is_airport_related
FROM UNNEST([
    STRUCT(1 AS rate_code_id, 'Standard rate' AS rate_code_name, 'Standard' AS rate_category, FALSE AS is_airport_related),
    STRUCT(2 AS rate_code_id, 'JFK' AS rate_code_name, 'Airport' AS rate_category, TRUE AS is_airport_related),
    STRUCT(3 AS rate_code_id, 'Newark' AS rate_code_name, 'Airport' AS rate_category, TRUE AS is_airport_related),
    STRUCT(4 AS rate_code_id, 'Nassau or Westchester' AS rate_code_name, 'Regional' AS rate_category, FALSE AS is_airport_related),
    STRUCT(5 AS rate_code_id, 'Negotiated fare' AS rate_code_name, 'Negotiated' AS rate_category, FALSE AS is_airport_related),
    STRUCT(6 AS rate_code_id, 'Group ride' AS rate_code_name, 'Shared ride' AS rate_category, FALSE AS is_airport_related)
])