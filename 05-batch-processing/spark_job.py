from pyspark.sql import SparkSession, functions as F
import argparse

parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

parser.add_argument('--input_green', required=True)
parser.add_argument('--input_yellow', required=True)
parser.add_argument('--output', required=True)

args = parser.parse_args()

input_green = args.input_green
input_yellow = args.input_yellow
output = args.output

spark = SparkSession.builder\
          .appName("test")\
          .getOrCreate()

df_green = spark.read.parquet(input_green)
df_green = df_green\
            .withColumnRenamed('lpep_pickup_datetime', 'pickup_datetime')\
            .withColumnRenamed('lpep_dropoff_datetime', 'dropoff_datetime')

df_yellow = spark.read.parquet(input_yellow)
df_yellow = df_yellow\
            .withColumnRenamed('tpep_pickup_datetime', 'pickup_datetime')\
            .withColumnRenamed('tpep_dropoff_datetime', 'dropoff_datetime')

# standardize schemas
common_cols = [col for col in df_green.columns if col in df_yellow.columns]
df_green_sel = df_green.select(common_cols).withColumn('service_type', F.lit('green'))
df_yellow_sel = df_yellow.select(common_cols).withColumn('service_type', F.lit('yellow'))

# merge datasets and save in view
df_trips_data = df_green_sel.unionAll(df_yellow_sel)
df_trips_data.createTempView('trips_data')

# compute monthly metrics
df_result = spark.sql("""
  SELECT 
      -- Revenue grouping 
      PULocationID AS revenue_zone,
      date_trunc('month', pickup_datetime) AS revenue_month, 
      service_type, 

      -- Revenue calculation 
      SUM(fare_amount) AS revenue_monthly_fare,
      SUM(extra) AS revenue_monthly_extra,
      SUM(mta_tax) AS revenue_monthly_mta_tax,
      SUM(tip_amount) AS revenue_monthly_tip_amount,
      SUM(tolls_amount) AS revenue_monthly_tolls_amount,
      SUM(improvement_surcharge) AS revenue_monthly_improvement_surcharge,
      SUM(total_amount) AS revenue_monthly_total_amount,
      SUM(congestion_surcharge) AS revenue_monthly_congestion_surcharge,

      -- Additional calculations
      AVG(passenger_count) AS avg_monthly_passenger_count,
      AVG(trip_distance) AS avg_monthly_trip_distance
  FROM
      trips_data
  GROUP BY
      1, 2, 3
  """)

# write results to parquet
df_result.coalesce(1).write.parquet(output, mode='overwrite')


spark.stop()