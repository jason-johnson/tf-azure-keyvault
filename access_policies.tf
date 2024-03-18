resource "azurerm_key_vault_access_policy" "manager" {
  count        = var.use_rbac ? 1 : 0
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.example.object_id

  key_permissions = local.access_policy_map["key_permissions"]["manage"]
  secret_permissions = local.access_policy_map["secret_permissions"]["manage"]
  certificate_permissions = local.access_policy_map["certificate_permissions"]["manage"]
}

resource "azurerm_key_vault_access_policy" "permissions" {
    for_each = local.access_policy_permissions

    key_vault_id = azurerm_key_vault.main.id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = each.value.object_id

    key_permissions = local.access_policy_map["key_permissions"][each.value.key_permissions]
    secret_permissions = local.access_policy_map["secret_permissions"][each.value.secret_permissions]
    certificate_permissions = local.access_policy_map["certificate_permissions"][each.value.certificate_permissions]
}
