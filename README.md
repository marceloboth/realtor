# README

Simple template to start a project with devise, view components, rspec, stimulus and tailwind.

`rails new -t template project-name`

then rename the databases on database.yml
and the containers name on docker-compose.yml

Run docker compose to build all containers

`docker compose up -d --build`

Install dependencies and create the database

`docker exec -it container-name bin/docker-entrypoint`

`docker exec -it container-name bin/dev`

open localhost:3000
