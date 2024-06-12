const String getMyCompanyUsersQuery = """
query(\$companyId: ID!){
  getMyCompanyUsers(companyId: \$companyId) {
  id
   role
    name
    email
    enabled
    permission {
      id
      name
    }
  }
}
""";

const String getAllPermissionsQuery = """
query{
  getAllPermissions {
   id
   name
  }
}
""";

const String updatePermissionMutation = """
mutation editUserProfile(\$id: ID!, \$name: String, \$role: String, \$permissions: [String],\$enabled: Boolean,) {
  editUserProfile(id: \$id, name: \$name, role: \$role, permissions: \$permissions, enabled: \$enabled) {
    id
    role
    name
    email
    enabled
    permission {
      id
      name
    }
    
  }
}

""";
