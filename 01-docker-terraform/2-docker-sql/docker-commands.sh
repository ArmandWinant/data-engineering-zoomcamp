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