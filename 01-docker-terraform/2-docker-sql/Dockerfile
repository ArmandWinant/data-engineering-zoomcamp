FROM python:3.9

RUN apt-get install curl
RUN pip install pandas pyarrow sqlalchemy psycopg2

WORKDIR /app
COPY ingest_parquet_data.py ingest_parquet_data.py

ENTRYPOINT [ "python", "ingest_parquet_data.py" ]