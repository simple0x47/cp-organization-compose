db = db.getSiblingDB("cp_organization");

db.member.createIndex({ "Email": 1, "OrgId": 1 }, { unique: true });