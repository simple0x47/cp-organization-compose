db = db.getSiblingDB("cp_organization");

db.organization.insertOne(
    {
        country: "es",
        name: "default",
        address: "not your business",
        permissions: [
            "read_org",
            "update_org",
            "delete_org",
            "request_permission_org",
            "read_member",
            "update_member",
            "delete_member",
            "create_invitation_code",
            "read_invitation_code",
            "update_invitation_code",
            "delete_invitation_code",
            "create_role",
            "read_role",
            "update_role",
            "delete_role"
        ],
        default_organization: true
    }
);