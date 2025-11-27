resource "azurerm_key_vault" "main" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  enable_rbac_authorization     = var.use_rbac
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = local.network_acls
    content {
      bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
    
  }

  sku_name = var.sku_name
}
