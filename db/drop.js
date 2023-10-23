db = db.getSiblingDB("cp_organization");

if (db) {
    db.dropDatabase();
}