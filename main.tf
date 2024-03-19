/**
 * # Azure Keyvault
 *
 * Terraform Module for creating Keyvault and related resources in Azure
 *
 * This module tries to create a nice interface for managing Keyvaults in Azure. It
 * allows configuration with old style access policies or with new style RBAC policies.
 * It also manages dependencies to ensure resources are created in the correct order.
 */

data "azurerm_client_config" "current" {}