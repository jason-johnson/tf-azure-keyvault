module "keyvault" {
    source = "./.."

    name = "mykv"
    resource_group_name = "myresourcegroup"
    sku_name = "premium"
    use_rbac = false
    permissions = [
        {
            object_id = "00000000-0000-0000-0000-000000000000"
            key_permissions = "read"
            secret_permissions = "read"
            certificate_permissions = "read"
        }
    ]    
}