#!/bin/bash

if [[ $CP_ENVIRONMENT -eq 0 ]]; then
  echo "Development mode"
  export $(cat ./env/dev.env | xargs)
elif [[ $CP_ENVIRONMENT -eq 1 ]]; then
  echo "Github Actions mode"
  export $(cat ./env/actions.env | xargs)
elif [[ $CP_ENVIRONMENT -eq 2 ]]; then
  echo "Production mode"
  export $(cat ./env/prod.env | xargs)
else
  echo "Default development mode"
  export $(cat ./env/dev.env | xargs)
fi

# Set initial credentials for RabbitMQ & MongoDB
if [[ $1 -eq 1 ]]; then
  echo "Initialization mode: ON"
  export RABBITMQ_DEFAULT_USER=$(bws secret get "$CP_ORGANIZATION_AMQP_USERNAME_SECRET" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
  export RABBITMQ_DEFAULT_PASS=$(bws secret get "$CP_ORGANIZATION_AMQP_PASSWORD_SECRET" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
  export MONGO_INITDB_ROOT_USERNAME=$(bws secret get "$CP_ORGANIZATION_MONGODB_USERNAME_SECRET" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
  export MONGO_INITDB_ROOT_PASSWORD=$(bws secret get "$CP_ORGANIZATION_MONGODB_PASSWORD_SECRET" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo docker compose stop
  sudo docker compose rm -f cp-organization
  sudo docker compose pull
  sudo docker compose up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose stop
  docker compose rm -f cp-organization
  docker compose pull
  docker compose up -d
fi

if [[ $1 -eq 1 ]]; then
  echo "Initializing database..."
  sleep 5
  sh db_init.sh
fi

# CP-ORGANIZATION fails on the first start.

sleep 1

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo docker compose up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose up -d
fi