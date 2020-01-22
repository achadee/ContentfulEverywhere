# Contentful Everywhere

Offline syncing tool to manage Contentful entries

## Getting Started

This project runs on Docker, so you can run it on a container service like [ECS]( https://aws.amazon.com/ecs/) or you can run it locally buy [installing docker](https://docs.docker.com/install/) on your machine


### Installing

Clone the repo into a folder of your choice

```
git clone https://github.com/achadee/ContentfulEverywhere
```
If you are running the service on docker-compose make sure you set your contentful ENV variables in the `contentful.local.env` before you start

```bash
CONTENTFUL_SPACE_ID=<your_space_id>
CONTENTFUL_ACCESS_TOKEN=<your_access_token>
```
Otherwise make sure your enviroment variables `CONTENTFUL_SPACE_ID` & `CONTENTFUL_ACCESS_TOKEN` are set on your hosted container

Optionally under `config/contentful.yml` you can set the frequency of the syncs. The default is 1 minute
```yml
sync_interval: 5
sync_interval_unit: minutes
```

To start the service on docker-compose run the docker-compose up command

```
docker-compose up
```

You can test if the service is running by running the `docker ps` command

```bash
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                    NAMES
817cadb26021        contentfuleverywhere_web         "run.sh bash -c 'rm …"   13 seconds ago      Up 12 seconds       0.0.0.0:3000->3000/tcp   contentfuleverywhere_web_1
8a02ba6a1fce        contentfuleverywhere_clockwork   "run.sh bash -c 'rm …"   13 seconds ago      Up 12 seconds       3000/tcp                 contentfuleverywhere_clockwork_1
60c3c3d06a23        postgres                         "docker-entrypoint.s…"   2 hours ago         Up 12 seconds       5432/tcp                 contentfuleverywhere_db_1
```

There should be 3 services running on the container

|service|responsibility|
|-------|--------------|
|contentfuleverywhere_web|Provides a REST API to retrieve data via HTTP|
|contentfuleverywhere_clockwork|Runs a cron job to sync data from Contentful|
|postgres|database to persist data locally|

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```
