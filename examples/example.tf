module "keyvault" {
    source = "./.."

    name = "mykv"
    resource_group_name = "myresourcegroup"
    location = "westeurope"
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "premium"
    use_rbac = false
    managing_object_id = data.azurerm_client_config.current.object_id
    permissions = [
        {
            object_id = "00000000-0000-0000-0000-000000000000"
            key_permissions = "read"
            secret_permissions = "read"
            certificate_permissions = "read"
        },
        {
            object_id = "11111111-0000-0000-0000-000000000000"
            key_permissions = "contribute"
            secret_permissions = "contribute"
            certificate_permissions = "contribute"
        }
    ]

    secrets = [
        {
            name = "secret1"
            value = "value1"
        },
        {
            name = "secret2"
            value = "value2"
        }
    ]
}