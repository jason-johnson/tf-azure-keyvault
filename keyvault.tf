data "namep_azure_name" "main" {
  name     = var.name
  location = var.location
  type     = "azurerm_key_vault"
}

resource "azurerm_key_vault" "main" {
  name                        = data.namep_azure_name.main.result
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = var.use_rbac

  sku_name = var.sku_name
}
