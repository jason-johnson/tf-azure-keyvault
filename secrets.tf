resource "azurerm_key_vault_secret" "main" {
    count         = length(var.secrets)
    name          = var.secrets[count.index].name
    value         = var.secrets[count.index].value
    key_vault_id  = azurerm_key_vault.main.id

    depends_on = [ azurerm_key_vault_access_policy.manager, azurerm_role_assignment.manager, azurerm_role_assignment.manager_roles["secret_permissions"] ]
}