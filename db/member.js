db = db.getSiblingDB("cp_organization");

db.member.createIndex({ "userId": 1, "organizationId": 1 }, { unique: true });