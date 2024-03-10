docker compose down --rmi all --volumes --remove-orphans

docker compose up -d --build
docker exec -it terminal /bin/bash