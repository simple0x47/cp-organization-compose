db = db.getSiblingDB("cp_organization");

db.organization_permission.createIndex(
    {
        Id: "text"
    },
    {
        unique: true
    }
);

db.organization_permission.insertMany(
    [
        // Organization permissions
        {
            Id: "read_org"
        },
        {
            Id: "update_org"
        },
        {
            Id: "delete_org"
        },
        {
            Id: "request_permission_org"
        },

        // Member permissions
        {
            Id: "read_member"
        },
        {
            Id: "update_member"
        },
        {
            Id: "delete_member"
        },

        // Invitation code permissions
        {
            Id: "create_invitation_code"
        },
        {
            Id: "read_invitation_code"
        },
        {
            Id: "update_invitation_code"
        },
        {
            Id: "delete_invitation_code"
        },

        // Role permissions
        {
            Id: "create_role",
        },
        {
            Id: "read_role",
        },
        {
            Id: "update_role",
        },
        {
            Id: "delete_role"
        }
    ]
);