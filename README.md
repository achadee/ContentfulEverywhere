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

* Delete all your local data (so you can sync from the first entry again)

## Running the tests

You can run tests by running the command

```
docker exec -it contentfuleverywhere_web_1 rails test
```
## Design choices

### architecture

I will go ove my design choices here so you have a better understanding of the system

This is the basic architecture of the system

![data architecture](https://images.ctfassets.net/5vmd0zjzbdm9/7EOKmkiV9gzVCfnNAKi332/abd8b79ea0d394be6d80257cdf52f946/Untitled_drawing.jpg?h=250)

I used Rails for the API, and Clockwork for the Cron task, I used ActiveJob for the queuing, Currently this is in memory queuing which can be easily replace with a redis alternative such as sidekiq or resque. 

### Models

<b>SyncLog</b>

Stores a record of an attempt to sync, will get created when the user manually runs a sync, or the cronjob triggers a `'sync.content'` job

|field|description|type|
|-----|-----------|----|
|id | unique identifier | Integer |
|status | the status of the sync| Can be the values `STARTING`, `IN_PROGRESS`, `COMPLETED`, `FAILED` |
|delta token |the url of the next delta sync | eg. http://cdn.contentful.com/spaces/5vmd0zjzbdm9/envi... |
|created_at | the time the sync was run | DateTime |
|updated_at | if the record gets updated, not really used (yet) | DateTime |
|time_out_at | the time that the sync times out. Since you can't run multiple syncs at the same time, if a sync exceptions in the state `STARTING` or `IN_PROGRESS` the time out field will catogorise the sync as "finished" once it exceeds the value | DateTime |

<b>Entry</b>

Stores a contentful Entry record. A synclog will trigger a sync, which will create or update one or many entries

|field|description|type|
|-----|-----------|----|
|id | unique local identifier | Integer |
|entry_id | contentful id| String |
| created_on_contentful_at | the time the content was added to contentful | DateTime |
| created_at | the time the content was synced to the local machine | DateTime |
| updated_at | the time the content was synced as an update to the local machine | DateTime |
| data | Unstructed serialised content | ```{"sys":{"space":{"sys":{"type":"Link","linkType":"Space","id":"5vmd0zjzbdm9"}},"id":"15jwOBqpxqSAOy2eOO4S0m","type":"Entry","createdAt":"2020-01-04T04:47:27.203Z","updatedAt":"2020-01-04T04:47:27.203Z","environment":{"sys":{"id":"master","type":"Link","linkType":"Environment"}},"revision":1,"contentType":{"sys":{"type":"Link","linkType":"ContentType","id":"person"}}},"fields":{"name":"John Doe","title":"Web Developer","company":"ACME","short_bio":"Research and recommendations for modern stack websites.","email":"john@doe.com","phone":"0176 / 1234567","facebook":"johndoe","twitter":"johndoe","github":"johndoe","image":{"sys":{"type":"Link","link_type":"Asset","id":"7orLdboQQowIUs22KAW4U"}}}}```|

ive indexed the `entry_id` and `created_on_contentful_at` for faster query lookups
