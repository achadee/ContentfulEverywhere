# Contentful Everywhere

Offline syncing tool to manage Contentful entries

## Getting Started

This project runs on Docker, so you can run it on a container service like [ECS]( https://aws.amazon.com/ecs/) or you can run it locally buy [installing docker](https://docs.docker.com/install/) on your machine


### Installing

Clone the repo into a folder of your choice

```
git clone https://github.com/achadee/ContentfulEverywhere
```
If you are running the service on docker-compose make sure you set your contentful ENV variables in the `contentful.local.env` before you start, if `contentful.local.env` doesn't exist (because I set git ignore on it) create a new one in the root directory:

<pre>
ContentfulEverywhere/
├── app
├── bin
├── config
├── ...
├── <b>contentful.local.env</b>
└── ...
</pre>

with the contents:

```bash
CONTENTFUL_SPACE_ID=<your_space_id>
CONTENTFUL_ACCESS_TOKEN=<your_access_token>
```
Otherwise make sure your environment variables `CONTENTFUL_SPACE_ID` & `CONTENTFUL_ACCESS_TOKEN` are set on your hosted container

Run the setup command, this will build the containers for the first time and install a database

```
./setup.sh
```

### Usage

To start the service on docker-compose run the docker-compose up command if you havnt already

```
docker-compose up -d
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

### Configuration

Optionally under `lib/clock.rb` you can set the frequency of the syncs. The default is 1 minute
```ruby
every(5.minutes, 'sync.content')
```

## Viewing your content

All your content can be accessed locally via [localhost:3000/entries](http://localhost:3000/entries)

By default we grab the first 100 entries from page 0 you can query any page using the `page` and `page_size` query parameters

eg. `localhost:3000/entries?page=12&page_size=10`

## Accessing the welcome screen

![Welcome screen](https://images.ctfassets.net/5vmd0zjzbdm9/2fwdivHUn2oXAYnSTajEKV/17d6323816d415f7967b19b8096213a9/Screen_Shot_2020-01-24_at_10.35.45_am.png?h=250)

I've provided a welcome screen at [localhost:3000](http://localhost:3000) here you can

* View your local entries

* Run a manual Sync

* Delete all your local data

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```
