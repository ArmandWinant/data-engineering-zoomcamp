import pandas as pd
import subprocess
import pyarrow.parquet as pq
from sqlalchemy import create_engine
from time import time
import argparse

def db_engine(user, password, host, port, db_name):
  return create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db_name}')

def download_parquet_file(url, filename):
  subprocess.run(['curl', '-s', '-o', filename, url])
  parquet_file = pq.ParquetFile(filename)
  return parquet_file

def transform_load_parquet(parquet_file, engine, table_name, overwrite=False):
  for i, batch in enumerate(parquet_file.iter_batches(batch_size=100000)):
    t_start = time()
    batch_df = batch.to_pandas()

    batch_df.rename(columns={
      'VendorID': 'vendor_id',
      'RatecodeID': 'ratecode_id',
      'PULocationID': 'pickup_location_id',
      'DOLocationID': 'dropoff_location_id'
    }, inplace=True)

    if_exists = 'replace' if i == 0 and overwrite else 'append'
    batch_df.to_sql(con=engine, name=table_name, if_exists=if_exists, index=False)
    
    t_end = time()

    print(f"Loaded {batch_df.shape[0]} rows to {table_name} in {(t_end - t_start):.3f} seconds")


def main(params):
  username = params.user
  password = params.password
  host = params.host
  port = params.port
  db_name = params.db_name
  table_name = params.table_name
  url = params.url

  filename = 'temp.parquet'

  engine = db_engine(username, password, host, port, db_name)
  parquet_file = download_parquet_file(url, filename)

  transform_load_parquet(parquet_file, engine, table_name, overwrite=True)


if __name__=="__main__":
  parser = argparse.ArgumentParser(description='Ingest Parquet data to Postgres')

  parser.add_argument('--user', help='postgres username')
  parser.add_argument('--password', help='postgres password')
  parser.add_argument('--host', help='postgres host')
  parser.add_argument('--port', help='postgres port')
  parser.add_argument('--db_name', help='postgres database')
  parser.add_argument('--table_name', help='postgres table name')
  parser.add_argument('--url', help='parquet file URL')

  argparse = parser.parse_args()

  main(argparse)