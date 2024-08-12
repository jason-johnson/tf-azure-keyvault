resource "azurerm_key_vault_secret" "main" {
  for_each     = { for secret in var.secrets : secret.name => secret }
  name         = each.value.name
  value        = each.value.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.manager, azurerm_role_assignment.manager, azurerm_role_assignment.manager_roles["secret_permissions"]]
}