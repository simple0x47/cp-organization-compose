#!/bin/bash
if [[ ! -n $CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN ]]; then
  echo "CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN is not set."
  exit 1
fi

if [[ $CP_PRODUCTION_ENVIRONMENT -eq 0 ]]; then
  echo "Staging mode"
  bws secret get "c3027aaf-5e20-4d8f-ac80-b0a401120ee9" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value' >> ./staging.env
  export $(cat ./staging.env | xargs)
  rm -f -R ./staging.env
elif [[ $CP_PRODUCTION_ENVIRONMENT -eq 1 ]]; then
  echo "Production mode"
  bws secret get "e0d1a3d9-30c1-4ead-ad96-b0a401123335" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value' >> ./prod.env
  export $(cat ./prod.env | xargs)
  rm -f -R ./prod.env
else
  echo "Default staging mode"
  bws secret get "c3027aaf-5e20-4d8f-ac80-b0a401120ee9" --access-token "$CP_ORGANIZATION_SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value' >> ./staging.env
  export $(cat ./staging.env | xargs)
  rm -f -R ./staging.env
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
  sudo -E docker compose up -d
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
  sudo -E docker compose up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose up -d
fi