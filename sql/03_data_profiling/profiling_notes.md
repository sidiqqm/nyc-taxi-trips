# Data Profiling Notes

## Dataset

- Source: NYC Yellow Taxi Trip Records
- Year: 2023

## Raw Table Strategy

Monthly raw tables:

- yellow_taxi_trips_2023_01
- yellow_taxi_trips_2023_02
- yellow_taxi_trips_2023_03
- yellow_taxi_trips_2023_04
- yellow_taxi_trips_2023_05
- yellow_taxi_trips_2023_06
- yellow_taxi_trips_2023_07
- yellow_taxi_trips_2023_08
- yellow_taxi_trips_2023_09
- yellow_taxi_trips_2023_10
- yellow_taxi_trips_2023_11
- yellow_taxi_trips_2023_12

Unified raw view:

- vw_yellow_taxi_trips_2023_union

## Profiling Findings

### 1. Row Count

Observation:

- banyak

### 2. Schema Issue

Observation:

- Tipe data dari passenger_count ada yang berbeda pada bulan tertentu
- The union view menstandarisasi passenger_count dengan float64 terlebih dahulu untuk profiling.

### 3. Date Range

Observation:

- ada beberapa rows yang melewati di rentang tahun 2023
- pada setiap source_month ada bulan yang < source_month

### 4. Null Values

Observation:

- Terdapat beberapa rows yang null pada kolom passenger_count

### 5. Invalid Passenger Count

Observation:

- Terdapat beberapa rows yang memeliki invalid values pada passenger_count baik itu <=0 atau > 6 di
  setiap bulannya

### 6. Invalid Trip Distance

Observation:

- terdapat invalid values dengan syarat <=0 miles dan suspicious values dengan syarat > 100 miles

### 7. Invalid Fare and Total Amount

Observation:

- Pada fare_amount dan total_amount ada beberapa rows yang terdapat invalid or suspicious values dengan ketentuan < 0
  atau == 0

### 8. Invalid Payment Type

Observation:

- Terdapat 6 jenis pembayaran dengan persentase tertinggi yaitu payment_type = 1
- Tidak ada jenis pembayaran selain dari 6 jenis tersebut

### 9. Invalid Location ID

Observation:

- tidak ada invalid location id berdasarkan pickup atau dropoff

### 10. Duplicate-like Records

Observation:

- Terdapat dua data yang memiliki duplikat dengan PULocationID 239 dan 132 dan DOLocation 239 dan 132
