#!/bin/bash

if [[ -n $1 ]]; then
  cd "$1" || exit 1
fi

if [[ "$ASPNETCORE_ENVIRONMENT" == "Development" ]]; then
  echo "Local development mode"
  export $(cat ./local.env | xargs)
elif [[ "$ASPNETCORE_ENVIRONMENT" == "Actions" ]]; then
  echo "Actions development mode"
  export $(cat ./actions.env | xargs)
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo -E docker compose -f dev.docker-compose.yaml up -d
elif [[ "$OSTYPE" == "darwin"* ]]; then
  docker compose -f dev.docker-compose.yaml up -d
fi

if [ ! -f ./mongosh ]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl https://downloads.mongodb.com/compass/mongosh-2.0.1-linux-x64.tgz --output mongosh.tgz
    tar -zxvf mongosh.tgz

    mv mongosh-2.0.1-linux-x64/bin/* ./
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl https://downloads.mongodb.com/compass/mongosh-2.0.1-darwin-arm64.zip --output mongosh.zip
    unzip -o mongosh.zip

    mv mongosh-2.0.1-darwin-arm64/bin/* ./
  fi
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [[ ! "$(sudo docker ps -a | grep dev-mongodb)" ]]; then
    sleep 5s
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ ! "$(docker ps -a | grep dev-mongodb)" ]]; then
    sleep 5
  fi
fi

chmod +x mongosh
./mongosh "$ORGANIZATION_MONGODB_URI" --username "$ORGANIZATION_MONGODB_USER" --password "$ORGANIZATION_MONGODB_PASS" --file ./db/drop.js --file ./db/organization_permission.js --file ./db/organization.js --file ./db/role.js --file ./db/member.js --file ./db/invitation_code.js