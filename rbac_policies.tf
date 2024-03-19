resource "azurerm_role_assignment" "manager" {
  count                = var.use_rbac ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.managing_object_id
}

resource "azurerm_role_assignment" "manager_roles" {
  for_each             = toset(var.use_rbac ? ["key_permissions", "secret_permissions", "certificate_permissions"] : [])

  scope                = azurerm_key_vault.main.id
  role_definition_name = local.rbac_policy_map[each.key].manage
  principal_id         = var.managing_object_id
}

resource "azurerm_role_assignment" "roles" {
  for_each             = { for e in local.rbac_policy_permissions : "${e.object_id}-${e.permission}" => e }
  scope                = azurerm_key_vault.main.id
  role_definition_name = each.value.permission
  principal_id         = each.value.object_id
}