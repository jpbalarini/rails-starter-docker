# About this project

This project is intended to be used as a template for creating a Ruby on Rails project with Docker integration. You can either run it as a normal rails project via `rails server` or via docker `docker-compose up`.

# Setup
This project was intended to run with or without Docker. For both of them you will need to correctly set all the ENV variables under the `.env` file.
Create an `.env` file with some needed vars (example for docker):

# Setup

Be sure to pupulate your .env file. An example:
```
RUBY_VER=2.5.1
SECRET_KEY_BASE=SOME_SECRET_KEY_BASE;
POSTGRES_DB=rails-app
POSTGRES_USER=postgres
POSTGRES_PASSWORD=
PORT=80
```

This will difer on each machine/setup

# Running
Once setup is complete, you can spin everything up with:
```
docker-compose up --build
```
This will start the rails web server and a postgres database, building the image again (to take into account new changes).

# Useful commands
Get a list of running docker processes:
```
docker ps
```

Run a terminal inside a docker container
```
docker exec -it DOCKER_CONTAINER_NAME_OR_ID bash
```

Terminate everything:
```
docker compose down
```

Spin up specific containers from the `docker-compose` file:
```
docker compose up web
```
This will only start the web server.

# How to run seeds
1. `docker exec -it rails_starter_web bash`
2. `bundle exec rails db:seed`
