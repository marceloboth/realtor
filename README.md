# README

Run docker compose to build all containers

```shell
docker compose up -d --build
```

Install dependencies and create the database

```shell
docker exec -it realtor-ruby bin/docker-entrypoint
```

```shell
docker exec -it realtor-ruby bin/dev
```

open localhost:3000
