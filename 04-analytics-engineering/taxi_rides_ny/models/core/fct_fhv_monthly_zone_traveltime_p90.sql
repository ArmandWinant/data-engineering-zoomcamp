with trips_data as (
  select
    year,
    month,
    pickup_datetime,
    pickup_locationid,
    pickup_zone,
    dropoff_datetime,
    dropoff_locationid,
    dropoff_zone,
    {{ dbt.datediff("pickup_datetime", "dropoff_datetime", "second") }} as trip_duration, 
  from {{ ref('dim_fhv_trips') }}
),
duration_percentiles as (
  select distinct
    *,
    percentile_cont(trip_duration, .9) over (partition by year, month, pickup_locationid, dropoff_locationid) as trip_duration_90p
  from trips_data
)
select distinct
  year,
  month,
  pickup_zone,
  dropoff_zone,
  trip_duration_90p,
  rank() over (partition by year, month, pickup_zone order by trip_duration_90p desc) as trip_duration_90p_rank
FROM duration_percentiles