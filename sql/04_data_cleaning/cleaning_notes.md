# Data Cleaning Notes

## Project

End-to-End NYC Taxi Trip Analytics

## Cleaning Scope

Source data:

- Raw monthly yellow taxi trip tables
- Raw view: vw_yellow_taxi_trips_2023_union

## Key Raw Data Issues Found

### 1. Schema mismatch

passenger count kolom memiliki tipe data yang tidak konsisten di Parquet files.

Handling:

- Table dipisahkan di setiap bulannya.
- Table raw tersebut disatukan di view kemudian di-standardizes tipe data passenger_count sebagai FLOAT64.
- Pada Cleaning table di-converts passenger_count ke INT64 hanya ketika valid integer.

### 2. Pickup date outside 2023

Beberapa baris memiliki pickup_datetime di luar dari 2023.

Handling:

- Baris yang di luar dari 2023 dikeluarkan dari cleaned_table.
- Baris baris tersebut dimasukkan ke dalam rejected_table.

### 3. Source month mismatch

Beberapa records memiliki source_month yang berbeda pada pickup_year_month.

Handling:

- Records tidak otomatis masuk ke rejected_table kalo pickup_date walaupun berada di rentang waktu 2023.
- flag dibuat: is_source_month_mismatch.
- Untuk kebutuhan business analysis akan digunakan pickup_datetime bukan source_month.

### 4. Invalid trip datetime

Beberapa record punya dropoff_datetime < pickup_datetime. Maksudnya adalah waktu penumpang turun lebih awal dari penumpang tersebut naik

Handling:

- Record tersebut ditolak atau dimasukkan rejected_table.

### 5. Invalid passenger count

Rules:

- passenger_count tidak boleh null .
- passenger_count harus integer.
- passenger_count must dan nilainya antara 1 sampai 6.

### 6. Invalid trip distance

Rules:

- trip_distance harus lebih dari 0.

### 7. Invalid fare and amount

Rules:

- fare_amount harus lebih dari 0 .
- total_amount harus lebih dari 0.
- tip_amount tidak boleh kurang dari 0 atau negatif.

### 8. Invalid payment type

Rules:

- payment_type harus ada di rentang 0 sampai 5.

## Output Tables

### Cleaning base table

`nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`

### Rejected table

`nyc_taxi_staging.rejected_yellow_taxi_trips`

### Cleaned table

`nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`

## Important Notes

- Raw data tidak boleh dimodified.
- Cleaning rules terdokumentasi dan producable.
- Invalid records tidak didelete permanen.
- Source month mismatch is flagged, not automatically rejected.
- Business date analysis harus menggunakan pickup_date bukan source_month.