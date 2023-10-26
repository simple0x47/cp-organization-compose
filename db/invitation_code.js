db = db.getSiblingDB("cp_organization");

db.invitation_code.createIndex({ "Code": 1 }, { unique: true });