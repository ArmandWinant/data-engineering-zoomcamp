import pandas as pd
import subprocess
import pyarrow.parquet as pq
from sqlalchemy import create_engine
from time import time

def db_engine(user, password, host, port, db_name):
  return create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db_name}')

def download_file(url, filename):
  subprocess.run(['curl', '-s', '-o', filename, url])
  parquet_file = pq.ParquetFile(filename)
  return parquet_file

def transform_load_parquet(parquet_file, engine, table_name, overwrite=False):
  for i, batch in enumerate(parquet_file.iter_batches(batch_size=100000)):
    t_start = time()
    batch_df = batch.to_pandas()

    batch_df.tpep_pickup_datetime = pd.to_datetime(batch_df.tpep_pickup_datetime)
    batch_df.tpep_dropoff_datetime = pd.to_datetime(batch_df.tpep_dropoff_datetime)

    if_exists = 'replace' if i == 0 and overwrite else 'append'
    batch_df.to_sql(con=engine, name=table_name, if_exists=if_exists, index=False)
    
    t_end = time()

    print(f"Loaded {batch_df.shape[0]} rows to {table_name} in {(t_end - t_start):.3f} seconds")

engine = db_engine('root', 'root', 'localhost', 5433, 'ny_taxi')
url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
parquet_file = download_file(url, 'temp.parquet')

transform_load_parquet(parquet_file, engine, 'yellow_taxi_data')