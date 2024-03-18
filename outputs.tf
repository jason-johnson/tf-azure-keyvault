output "keyvault_id" {
    description = "The id of the keyvault"
    value = azurerm_key_vault.main.id
}

output "keyvalut_url" {
    description = "The url of the keyvault"
    value = azurerm_key_vault.main.vault_uri
  
}