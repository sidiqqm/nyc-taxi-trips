# End-to-End NYC Yellow Taxi Trip Analytics

## Project Overview

Project ini menganalisa data dari NYC Yellow taxi trip tahun 2023 untuk mengidentifikasi demand patterns, trip behavior, location performance, gross trip amount trends, payment behavior dan outlier impact.

Project didesain sebagai project end-to-end Data Analyst portofolio yang menggunakan BigQuery, dbt, SQL, Python dan Power BI.

## Business Problem
NYC Yellow Taxi menghasilkan jutaan trip records yang berisi informasi mengenai trip time, distance, fare, passenger count, payment method, serta pickup/drop-off zones. Namun, raw trip data belum siap digunakan untuk analisis bisnis karena masih dapat mengandung nilai yang tidak valid, outliers, perilaku pembayaran yang tidak konsisten, serta pola permintaan yang belum jelas.

Project ini bertujuan untuk mentransformasikan raw NYC Yellow Taxi trip data menjadi analytics-ready dataset menggunakan BigQuery SQL dan dbt, kemudian menganalisis demand patterns, revenue performance, trip behavior, location-based trends, serta payment behavior untuk mendukung pengambilan keputusan operasional dan bisnis.

## KPI Definition
| KPI | Tujuan |
|------|--------|
| Total Trips | Mengukur total permintaan perjalanan |
| Total Revenue | Mengukur total pendapatan yang dihasilkan |
| Total Fare | Mengukur total pendapatan tarif dasar sebelum biaya tambahan |
| Total Tip | Mengukur perilaku pelanggan dalam memberikan tip |
| Average Fare per Trip | Mengukur rata-rata tarif dasar per perjalanan |
| Average Revenue per Trip | Mengukur rata-rata total pendapatan per perjalanan |
| Average Trip Distance | Mengukur rata-rata jarak perjalanan |
| Average Trip Duration | Mengukur rata-rata durasi perjalanan |
| Average Tip Rate | Mengukur persentase tip terhadap tarif dasar |
| Credit Card Share | Mengukur proporsi perjalanan yang dibayar menggunakan kartu kredit |
| Cash Share | Mengukur proporsi perjalanan yang dibayar menggunakan uang tunai |


## Data Model

<img width="1119" height="1119" alt="data model" src="https://github.com/user-attachments/assets/77482e13-41bb-4063-a2d7-2d9651b5319d" />


### Fact Table

* `fact_yellow_taxi_trips`

### Dimension Tables

* `dim_date`
* `dim_location`
* `dim_payment_type`
* `dim_rate_code`


## Tech Stack

* Google BigQuery
* dbt Core with dbt-bigquery
* SQL
* Python
* Pandas
* Matplotlib
* Jupyter Notebook
* Power BI
* Git and GitHub


## How to Run

### 1. Configure dbt Profile

Buat profile Bigquery: 

```text
~/.dbt/profiles.yml
```

### 2. Run dbt Models

```bash
cd dbt/nyc_taxi_analytics

dbt debug
dbt run
dbt test
```

### 3. Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

### 4. Run Python Notebooks

Aktifkan python environment dan buka Jupyter:

```bash
source .venv/bin/activate
jupyter notebook
```

```text
├── dbt/
├── sql/
├── notebooks/
├── dashboard/
├── docs/
├── data/
└── README.md
```

## Author

Muhammad Siddiq
