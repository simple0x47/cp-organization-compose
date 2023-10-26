#!/bin/bash

export DEV_MONGO_INITDB_ROOT_USERNAME=guest
export DEV_MONGO_INITDB_ROOT_PASSWORD=guest

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

if [[ $1 -eq 1 ]]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sleep 3s
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    sleep 3
  fi
fi

chmod +x mongosh
./mongosh mongodb://localhost:27000 --username guest --password guest --file ./db/drop.js --file ./db/organization_permission.js --file ./db/organization.js --file ./db/role.js --file ./db/member.js --file ./db/invitation_code.js