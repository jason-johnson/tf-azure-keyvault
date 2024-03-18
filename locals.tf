locals {
    access_policy_map = {
        key_permissions = {
            manage = [
                "Get", "List", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Sign", "Verify", "GetAttributes", "UpdateAttributes", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
            ]
            read = [
                "Get", "List", "GetAttributes", "GetIssuers", "ListIssuers", "List"
            ]
            contribute = [
                "Get", "List", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Sign", "Verify", "GetAttributes", "UpdateAttributes", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
            ]
        }
        secret_permissions = {
            manage = [
                "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
            ]
            read = [
                "Get", "List", "GetAttributes"
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

    access_policy_permissions = var.use_rbac ? [] : var.permissions
    rbac_policy_permissions = var.use_rbac ? var.permissions : []
}