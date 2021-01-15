## App
http://localhost:3000

## Hasura Console
http://localhost:8080/console

## Keycloack Admin Console
http://localhost:8888/auth/admin/

## Postgres Admin
http://localhost/browser/

## Data, Schemas & Metadata

### Export postgres db schema (here lives hasura)
(this database is automatically created by the docker-compose file)
```
docker exec -ti docker_postgres_1 bin/bash
pg_dump --username=postgres --password --schema-only --schema=public postgres > postgres_schema.sql
exit
docker cp docker_postgres_1:/postgres_schema.sql .
```

### Export keycloak db data (here lives keycloak)
(this database is automatically created by the docker-compose file using init-user-db.sh)
```
docker exec -ti docker_postgres_1 bin/bash
pg_dump --username=postgres --password keycloak > keycloak_data.sql
exit
docker cp docker_postgres_1:/keycloak_data.sql .
```

### Export Hasura Metadata
```
1. Click settings icon
2. Click Export metadata
```

### Import postgres db schema
```
docker cp postgres_schema.sql docker_postgres_1:/postgres_schema.sql
docker exec -ti docker_postgres_1 bin/bash
psql --username=postgres --password postgres < postgres_schema.sql
exit
```

### Import keycloak db data
```
docker cp keycloak_data.sql docker_postgres_1:/keycloak_data.sql
docker exec -ti docker_postgres_1 bin/bash
psql --username=postgres --password keycloak < keycloak_data.sql
exit
```

### Import Hasura Metadata
```
1. Click settings icon
2. Click Import metadata
```
