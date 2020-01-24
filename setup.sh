#!/bin/bash
docker-compose build
docker-compose up -d
sleep 5s # Waits 5 seconds because it might take time for daemon to start up.

# because docker can name containers with prefixes, we search for the container
# name by the keyword
web="$(docker ps --format '{{.Names}}' | grep 'web')"
db="$(docker ps --format '{{.Names}}' | grep 'db')"
clockwork="$(docker ps --format '{{.Names}}' | grep 'clockwork')"


# if you have issues with the database not creating run this line
# eg. docker exec -it contentfuleverywhere_web_1 rake db:setup
docker exec -it "${web}" rake db:setup


# stop the services
docker stop "${web}"
docker stop "${db}"
docker stop "${clockwork}"
echo "Contentful everwhere is now setup, you can start the service by running the 'docker-compose up -d' command"
