# End-to-End NYC Yellow Taxi Trip Analytics

# B. Business Problem

## Problem Statement

NYC Yellow Taxi memiliki volume perjalanan yang besar dan pola demand yang bervariasi berdasarkan waktu, lokasi, payment type, fare amount, passenger behavior, dan route.

Namun, tanpa analisis yang terstruktur, raw trip data sulit digunakan untuk menjawab pertanyaan bisnis seperti:

1. Kapan demand taxi paling tinggi?
2. Area mana yang menghasilkan trip dan revenue terbesar?
3. Pola perjalanan seperti apa yang paling umum?
4. Bagaimana perilaku pembayaran pelanggan?
5. Apakah terdapat outlier atau data tidak valid yang dapat memengaruhi analisis?
6. Bagaimana performa revenue taxi berubah berdasarkan waktu dan lokasi?

---

# C. Business Objectives

Tujuan bisnis project ini adalah:

| No. | Objective | Penjelasan |
|---|---|---|
| **1** | **Analyze Demand Patterns** | Mengetahui jam, hari, dan bulan dengan jumlah trip tertinggi |
| **2** | **Measure Revenue Performance** | Mengukur total fare, total amount, tip, dan revenue per trip |
| **3** | **Understand Trip Behavior** | Menganalisis pola jarak, durasi, passenger count, dan route |
| **4** | **Identify Location Performance** | Menentukan pickup dan drop-off zone dengan demand dan revenue tertinggi |
| **5** | **Analyze Payment Behavior** | Menganalisis penggunaan cash, credit card, dan payment type lainnya |
| **6** | **Detect Outliers & Invalid Trips** | Mengidentifikasi trip tidak wajar yang dapat mengganggu business insights |
| **7** | **Build BI Dashboard** | Menyajikan KPI dan business insights melalui dashboard yang interaktif dan profesional |

---

# D. Business Questions

Business Questions menjadi dasar dalam menentukan **SQL analysis, EDA, statistical analysis, dan dashboard design**.

## 1. Demand Pattern

**BQ-01.** Pada jam berapa demand taxi paling tinggi?

**BQ-02.** Hari apa yang memiliki jumlah trip tertinggi?

**BQ-03.** Apakah weekday dan weekend memiliki pola demand yang berbeda?

**BQ-04.** Bagaimana tren jumlah trip per bulan?

**BQ-05.** Apakah terdapat peak hour tertentu pada pagi dan malam hari?

---

## 2. Revenue Performance

**BQ-06.** Berapa total revenue yang dihasilkan oleh Yellow Taxi?

**BQ-07.** Bagaimana tren revenue harian, mingguan, dan bulanan?

**BQ-08.** Area mana yang menghasilkan revenue tertinggi?

**BQ-09.** Berapa average revenue per trip?

**BQ-10.** Apakah trip dengan jarak lebih jauh selalu menghasilkan revenue yang lebih tinggi?

---

## 3. Location-Based Analysis

**BQ-11.** Pickup zone mana yang memiliki jumlah trip terbanyak?

**BQ-12.** Drop-off zone mana yang paling sering menjadi tujuan?

**BQ-13.** Borough mana yang menghasilkan demand terbesar?

**BQ-14.** Route pickup–drop-off mana yang paling populer?

**BQ-15.** Route mana yang menghasilkan revenue tertinggi?

---

## 4. Payment Behavior

**BQ-16.** Payment type apa yang paling sering digunakan?

**BQ-17.** Apakah credit card menghasilkan tip yang lebih tinggi dibandingkan cash?

**BQ-18.** Bagaimana distribusi tip berdasarkan payment type?

**BQ-19.** Apakah terdapat payment type dengan total amount yang tidak wajar?

---

## 5. Trip Behavior

**BQ-20.** Berapa rata-rata jarak perjalanan?

**BQ-21.** Berapa rata-rata durasi perjalanan?

**BQ-22.** Bagaimana distribusi passenger count?

**BQ-23.** Apakah trip pendek lebih dominan dibandingkan trip panjang?

**BQ-24.** Apakah terdapat trip dengan durasi, distance, atau fare yang tidak masuk akal?

---

# E. KPI Definition

KPI berikut digunakan sebagai metrik utama dalam **analysis, dashboard, dan business insight**.

## Main KPI

| KPI | Formula | Tujuan |
|---|---|---|
| **Total Trips** | `COUNT(*)` | Mengukur total demand |
| **Total Revenue** | `SUM(total_amount)` | Mengukur total revenue |
| **Total Fare** | `SUM(fare_amount)` | Mengukur pendapatan dasar sebelum komponen tambahan |
| **Total Tip** | `SUM(tip_amount)` | Mengukur total tip yang diterima |
| **Average Fare per Trip** | `AVG(fare_amount)` | Mengukur rata-rata fare per trip |
| **Average Revenue per Trip** | `AVG(total_amount)` | Mengukur rata-rata revenue per trip |
| **Average Trip Distance** | `AVG(trip_distance)` | Mengukur rata-rata jarak perjalanan |
| **Average Trip Duration** | `AVG(trip_duration_minutes)` | Mengukur rata-rata durasi perjalanan |
| **Average Tip Rate** | `SUM(tip_amount) / SUM(fare_amount)` | Mengukur kontribusi tip terhadap fare |
| **Credit Card Share** | `Credit Card Trips / Total Trips` | Mengukur proporsi pembayaran dengan credit card |
| **Cash Share** | `Cash Trips / Total Trips` | Mengukur proporsi pembayaran dengan cash |

---

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
