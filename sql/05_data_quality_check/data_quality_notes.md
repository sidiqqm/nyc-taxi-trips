# Data Quality Check Notes

## Project

End-to-End NYC Taxi Trip Analytics

## Checked Table

`nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`

## Supporting Tables

- `nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
- `nyc_taxi_staging.rejected_yellow_taxi_trips`
- `nyc_taxi_raw.taxi_zone_lookup`

## Data Quality Dimensions

### 1. Completeness

Checks:

- trip_id tidak boleh null
- pickup_datetime tidak boleh null
- dropoff_datetime tidak boleh null
- passenger_count tidak boleh null
- trip_distance tidak boleh null
- fare_amount tidak boleh null
- total_amount tidak boleh null

### 2. Uniqueness

Checks:

- trip_id harus unique
- duplicate business key sebaikya tidak ada setelah deduplication

### 3. Validity

Checks:

- pickup_date harus dalam rentang waktu 2023
- passenger_count harus diantara 0 sampai 5
- trip_distance harus lebih dari 0
- trip_duration_minutes harus lebih dari 0
- fare_amount harus lebih dari 0
- total_amount harus lebih dari 0
- tip_amount tidak boleh bernilai negatif

### 4. Consistency

Checks:

- dropoff_datetime harus lebih besar dari pickup_datetime
- payment_type harus mengikuti valid mapping
- rate_code_id sebaiknya mengikuti valid mapping

### 5. Referential Integrity

Checks:

- pickup_location_id harus ada di taxi_zone_lookup
- dropoff_location_id harus ada di taxi_zone_lookup

## Source Month Mismatch

Source month mismatch sebaiknya langsung dimasukkan ke dalam invalid value.

Reason:

- nilai source_month datangnya dari monthly raw file/table.
- business analysis sebaiknya menggunakan pickup_datetime dan pickup_year_month.

Handling:

- Tetap gunakan valid records
- Flag using is_source_month_mismatch
- Audit mismatch count dari source_month and pickup_year_month

## Data Quality Summary Table

Summary table:

`nyc_taxi_staging.dq_yellow_taxi_trips_2023_summary`

## Result

Fill this section after running the checks:

| Check | Status | Notes |
|---|---|---|
| Not null check |  |  |
| Unique trip_id check |  |  |
| Accepted values check |  |  |
| Range validation check |  |  |
| Relationship check |  |  |
| Duplicate check |  |  |
| Reconciliation check |  |  |
| Source month mismatch audit |  |  |
