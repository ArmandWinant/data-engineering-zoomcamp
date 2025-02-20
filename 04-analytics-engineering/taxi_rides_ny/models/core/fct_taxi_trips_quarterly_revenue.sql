with quarterly_revenues as (
  select
    service_type,
    year,
    quarter,
    sum(total_amount) as total_amount
  from {{ ref('fact_trips') }}
  group by 1, 2, 3
),
lagging_revenues as (
  select
    service_type,
    year,
    quarter,
    total_amount as current_total,
    lag(total_amount, 1) over (partition by service_type, quarter ORDER BY year) as previous_total
  from quarterly_revenues
)
select
  *,
  ROUND(100 * (current_total / nullif(previous_total, 0) - 1), 2) as yoy_quarterly_growth
from lagging_revenues