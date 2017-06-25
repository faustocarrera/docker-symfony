#!/bin/bash

docker-compose up --build
docker exec symfony_php php /app/app/console cache:clear --env=dev
docker exec symfony_php php /app/app/console cache:clear --env=prod
docker exec symfony_php chmod -R 777 /app/app/cache