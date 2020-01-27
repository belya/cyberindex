#! /bin/bash
#temporeraly import variables
export $(cat .env)
#run postgres and hasura in containers
docker-compose up -d
sleep 2
#init database with basic tables
docker exec -ti cyberindex_postgres psql -f /root/schema/transaction.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/block.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/validator.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/pre_commit.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/link.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/transaction.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/block.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/validator.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/pre_commit.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/link.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/transaction.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti cyberindex_postgres psql -f /root/schema/link.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
#create config.toml, put values from .env file to config.toml
cat config.sample >> config.toml
sed -i "/#1/a rpc_node=\"$RPC_URL\"" config.toml
sed -i "/rpc/a client_node=\"$LCD_URL\"" config.toml
sed -i "/port/a name=\"$POSTGRES_DB_NAME\"" config.toml
sed -i "/name/a user=\"$POSTGRES_USER_NAME\"" config.toml
sed -i "/user/a password=\"$POSTGRES_DB_PASSWORD\"" config.toml
#build cyberindexer and run it in container
docker build -t cyberindex:latest --build-arg JUNO_WORKERS=$JUNO_WORKERS .
docker run -d --name cyberindex --network="host" cyberindex:latest