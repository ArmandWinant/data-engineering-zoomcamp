# build image from docker file in the current directory
docker build -t <name>:<tag> .

# run container based on image
docker run -it --rm <name>:<tag>

# run postgres with env variables
docker run --rm -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5433:5432 \
postgres:latest

# run pgadmin with pgadmin
docker run --rm -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
dpage/pgadmin4

# NETWORK
# run postgres in network
docker run --rm -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5433:5432 \
  --network=pg-network \
  --name=pg-database \
postgres:latest

# run pgadmin in network
docker run --rm -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name=pg-admin \
dpage/pgadmin4

URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5433 \
  --db_name=ny_taxi \
  --table_name=yellow_taxi_data \
  --url=${URL}

# build and run ingest image
docker build -t taxi_ingest:v001 .

URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
docker run -it --rm \
  --network=pg-network \
  taxi_ingest:v001 \
  --user=root \
  --password=root \
  --host=pg-database \
  --port=5432 \
  --db_name=ny_taxi \
  --table_name=yellow_taxi_data \
  --url=${URL}

# run the ingest script against the custom network
URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
docker run -it --rm \
  --network=postgres-network \
  taxi_ingest:v001 \
  --user=root \
  --password=root \
  --host=database \
  --port=5432 \
  --db_name=ny_taxi \
  --table_name=yellow_taxi_data \
  --url=${URL}

# run the loop ingest script against the network
URL="https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"
docker run -it --rm \
  --network=postgres-network \
  taxi_zones_ingest:v001 \
  --user=root \
  --password=root \
  --host=database \
  --port=5432 \
  --db_name=ny_taxi \
  --table_name=taxi_zones_lookup \
  --url=${URL}

# HOMEWORK COMMANDS
docker build -t taxi_zones_ingest:v001 -f Dockerfile_zones .

URL="https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"
docker run -it --rm \
  --network=homework_default \
  taxi_zones_ingest:v001 \
  --user=postgres \
  --password=postgres \
  --host=postgres \
  --port=5432 \
  --db_name=ny_taxi \
  --table_name=taxi_zones_lookup \
  --url=${URL}
  
docker build -t taxi_trips_ingest:v001 -f Dockerfile_trips .

URL="https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-10.parquet"
docker run -it --rm \
  --network=homework_default \
  taxi_trips_ingest:v001 \
  --user=postgres \
  --password=postgres \
  --host=postgres \
  --port=5432 \
  --db_name=ny_taxi \
  --table_name=green_taxi_data \
  --url=${URL}