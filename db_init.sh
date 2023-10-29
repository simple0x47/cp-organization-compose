#!/bin/bash

CP_ORGANIZATION_MONGODB_CONNECTION_URI=$(bws secret get "5e03fb14-a33e-4aa1-bfc2-b09d01095743" --access-token "$SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
CP_ORGANIZATION_MONGODB_USERNAME=$(bws secret get "db1e4029-d899-4530-8146-b09d010738fb" --access-token "$SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')
CP_ORGANIZATION_MONGODB_PASSWORD=$(bws secret get "8c10778a-82d4-4e52-9444-b09d01072ab4" --access-token "$SECRETS_MANAGER_ACCESS_TOKEN" | jq -r '.value')

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

sleep 1

chmod +x mongosh
./mongosh $CP_ORGANIZATION_MONGODB_CONNECTION_URI --username $CP_ORGANIZATION_MONGODB_USERNAME --password $CP_ORGANIZATION_MONGODB_PASSWORD --file ./db/drop.js --file ./db/organization_permission.js --file ./db/organization.js --file ./db/role.js --file ./db/member.js --file ./db/invitation_code.js