#!/bin/bash
docker-compose build
docker-compose up -d
sleep 5s # Waits 5 seconds because it might take time for daemon to start up.
docker exec -it contentfuleverywhere_web_1 rake db:setup
# stop the services
docker stop contentfuleverywhere_web_1
docker stop contentfuleverywhere_db_1
docker stop contentfuleverywhere_clockwork_1
echo "Contentful everwhere is now setup, you can start the service by running the 'docker-compose up -d' command"
