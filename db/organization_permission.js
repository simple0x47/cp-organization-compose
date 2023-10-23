db = db.getSiblingDB("cp_organization");

db.organization_permission.createIndex(
    {
        id: "text"
    },
    {
        unique: true
    }
);

db.organization_permission.insertMany(
    [
        // Organization permissions
        {
            id: "read_org"
        },
        {
            id: "update_org"
        },
        {
            id: "delete_org"
        },
        {
            id: "request_permission_org"
        },

        // Member permissions
        {
            id: "read_member"
        },
        {
            id: "update_member"
        },
        {
            id: "delete_member"
        },

        // Invitation code permissions
        {
            id: "create_invitation_code"
        },
        {
            id: "read_invitation_code"
        },
        {
            id: "update_invitation_code"
        },
        {
            id: "delete_invitation_code"
        },

        // Role permissions
        {
            id: "create_role",
        },
        {
            id: "read_role",
        },
        {
            id: "update_role",
        },
        {
            id: "delete_role"
        }
    ]
);