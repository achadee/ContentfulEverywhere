# Contentful Everywhere

Offline syncing tool to manage Contentful entries

## Getting Started

This project runs on Docker, so you can run it on a container service like [ECS]( https://aws.amazon.com/ecs/) or you can run it locally buy [installing docker](https://docs.docker.com/install/) on your machine


### Installing

Clone the repo into a folder of your choice

```
git clone https://github.com/achadee/ContentfulEverywhere
```
If you are running the service on docker-compose make sure you set your contentful ENV variables in the `docker-compose.yml` before you start

```yml
environment:
  CONTENTFUL_SPACE_ID: <your_space_id>
  CONTENTFUL_ACCESS_TOKEN: <your_access_token>
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

If all is well port 3000 should be exposed to Contentful Everywhere!

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```
