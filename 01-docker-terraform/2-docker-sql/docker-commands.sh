# build image from docker file in the current directory
docker build -t <name>:<tag> .

# run container based on image
docker run -it --rm <name>:<tag>