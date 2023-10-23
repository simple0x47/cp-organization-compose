db = db.getSiblingDB("cp_organization");

db.invitation_code.createIndex({ "code": 1 }, { unique: true });