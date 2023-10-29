#!/bin/bash
if [[ ! -n $SECRETS_MANAGER_ACCESS_TOKEN ]]; then
  echo "SECRETS_MANAGER_ACCESS_TOKEN is not set."
  exit 1
fi

# Set initial credentials for MongoDB
if [[ $1 -eq 1 ]]; then
  echo "Initialization mode: ON"
  export MONGO_INITDB_ROOT_USERNAME=$(bws secret get "db1e4029-d899-4530-8146-b09d010738fb" --access-token "$SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
  export MONGO_INITDB_ROOT_PASSWORD=$(bws secret get "8c10778a-82d4-4e52-9444-b09d01072ab4" --access-token "$SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo docker compose stop cp-organization
  sudo docker compose rm -f cp-organization
  sudo docker compose pull
  sudo -E docker compose up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose stop cp-organization
  docker compose rm -f cp-organization
  docker compose pull
  docker compose up -d
fi

if [[ $1 -eq 1 ]]; then
  echo "Initializing database..."
  
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sleep 5s
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    sleep 5
  fi

  ./db_init.sh
fi

# CP-ORGANIZATION fails on the first start.

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sleep 2s
elif [[ "$OSTYPE" == "darwin"* ]]; then
  sleep 2
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo -E docker compose up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose up -d
fi