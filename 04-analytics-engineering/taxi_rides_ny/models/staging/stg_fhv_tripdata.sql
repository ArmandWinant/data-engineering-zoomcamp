with tripdata as (
  select *
  from {{ source('staging', 'fhv_tripdata') }}
  where dispatching_base_num is not null
)
select
  -- identifiers
  unique_row_id as tripid,
  dispatching_base_num as dispatching_base_number,
  affiliated_base_number,
  {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
  {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,

  -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

  -- trip_info
  {{ dbt.safe_cast("SR_flag", api.Column.translate_type("integer")) }} as SR_flag  
from tripdata

{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}