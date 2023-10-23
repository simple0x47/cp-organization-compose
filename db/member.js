db = db.getSiblingDB("cp_organization");

db.member.createIndex({ "user_id": 1, "organization_id": 1 }, { unique: true });