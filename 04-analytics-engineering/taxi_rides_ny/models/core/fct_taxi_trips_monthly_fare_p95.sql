select distinct
  service_type,
  year || '-' || lpad(cast(month as string), 2, '0') as month,
  percentile_cont(fare_amount, .97) over (partition by service_type, month) as p97,
  percentile_cont(fare_amount, .95) over (partition by service_type, month) as p95,
  percentile_cont(fare_amount, .9) over (partition by service_type, month) as p90
from {{ ref('fact_trips') }}
where fare_amount > 0 and trip_distance > 0 and payment_type_description in ('Cash', 'Credit card')