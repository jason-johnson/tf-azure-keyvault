locals {
  access_policy_map = {
    key_permissions = {
      manage = [
        "Get", "List", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Sign", "Verify", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
      read = [
        "Get", "List"
      ]
      contribute = [
        "Get", "List", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Sign", "Verify", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
    }
    secret_permissions = {
      manage = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
      read = [
        "Get", "List"
      ]
      contribute = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
    }
    certificate_permissions = {
      manage = [
        "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
      ]
      read = [
        "Get", "GetIssuers", "List", "ListIssuers"
      ]
      contribute = [
        "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
      ]
    }

  }

  rbac_policy_map = {
    key_permissions = {
      manage     = "Key Vault Crypto Officer"
      read       = "Key Vault Crypto User"
      contribute = "Key Vault Crypto User"
    }
    secret_permissions = {
      manage     = "Key Vault Secrets Officer"
      read       = "Key Vault Secrets User"
      contribute = "Key Vault Secrets Officer"
    }
    certificate_permissions = {
      manage     = "Key Vault Certificates Officer"
      read       = "Key Vault Certificates Officer"
      contribute = "Key Vault Certificates Officer"
    }
  }

  access_policy_permissions = var.use_rbac ? [] : var.permissions
  rbac_policy_permissions = flatten([for e in(var.use_rbac ? var.permissions : []) :
    [for f in ["key_permissions", "secret_permissions", "certificate_permissions"] :
  { name = e.name, object_id = e.object_id, permission = local.rbac_policy_map[f][e[f]] }]])
}