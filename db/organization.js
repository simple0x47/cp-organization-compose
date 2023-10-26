db = db.getSiblingDB("cp_organization");

db.organization.insertOne(
    {
        Id: "-1",
        Name: "default",
        Address: {
            Country: "ES",
            Province: "Albacete",
            City: "Villarrobledo",
            Street: "Calle",
            Number: "85",
            Additional: "",
            PostalCode: "02600"
        },
        Permissions: [
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
        DefaultOrganization: true
    }
);