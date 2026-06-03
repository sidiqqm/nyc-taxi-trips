WITH trips AS (
  SELECT
    source_month,
    PULocationID,
    DOLocationID
  FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
),

zone AS (
  SELECT
    LocationID
  FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
)

SELECT
  t.source_month,
  COUNT(*) AS total_rows,

  COUNTIF(pu.LocationID IS NULL) AS invalid_pickup_location,
  COUNTIF(doz.LocationID IS NULL) AS invalid_dropoff_location

FROM trips t
LEFT JOIN zone pu
  ON t.PULocationID = pu.LocationID
LEFT JOIN zone doz
  ON t.DOLocationID = doz.LocationID
GROUP BY t.source_month
ORDER BY t.source_month;

-- check invalid location
SELECT
  PULocationID,
  COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
WHERE PULocationID NOT IN (
  SELECT LocationID
  FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
)
GROUP BY PULocationID
ORDER BY total_rows DESC;