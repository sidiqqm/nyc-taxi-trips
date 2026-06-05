SELECT
    COUNT(*) AS total_rows,
    COUNTIF(payment_type NOT IN (0,1,2,3,4,5)) AS invalid_payment_type,
    COUNTIF(payment_type_label NOT IN(
        'Credit card',
        'Cash',
        'No charge',
        'Dispute',
        'Unknown',
        'Voided trip'
  )) AS invalid_payment_type_label,

    COUNTIF(rate_code_id NOT IN (1,2,3,4,5,6)) AS invalid_rate_code_id,
    COUNTIF(rate_code_label NOT IN (
            'Standard rate',
            'JFK',
            'Newark',
            'Nassau or Westchester',
            'Negotiated fare',
            'Group ride'
    )) AS invalid_rate_code_label,

    COUNTIF(is_weekend NOT IN (TRUE, FALSE)) AS invalid_is_weekend,
    COUNTIF(is_source_month_mismatch NOT IN (TRUE, FALSE)) AS invalid_is_source_month_mismatch
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`