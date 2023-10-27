db = db.getSiblingDB("cp_organization");

db.member.createIndex({ "UserId": 1, "OrgId": 1 }, { unique: true });