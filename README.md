<!-- BEGIN_TF_DOCS -->
# Azure Keyvault

Terraform Module for creating Keyvault and related resources in Azure

This module tries to create a nice interface for managing Keyvaults in Azure. It
allows configuration with old style access policies or with new style RBAC policies.
It also manages dependencies to ensure resources are created in the correct order.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | default location to use if not specified | `string` | n/a | yes |
| <a name="input_managing_object_id"></a> [managing\_object\_id](#input\_managing\_object\_id) | object id of the user who will manage the keyvault | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the keyvault | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group to put the keyvault in | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | tenant id to use for the keyvault | `string` | n/a | yes |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | whether to enable disk encryption | `bool` | `true` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | network ACLs to apply to the keyvault | <pre>object({<br/>    bypass = string<br/>    default_action = string<br/>    ip_rules = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | list of users and policies to apply to the keyvault | <pre>list(object({<br/>    name                    = string<br/>    object_id               = string<br/>    key_permissions         = string<br/>    secret_permissions      = string<br/>    certificate_permissions = string<br/>  }))</pre> | `[]` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | whether to enable public network access | `bool` | `true` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | whether to enable purge protection | `bool` | `false` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | list of secrets to add to the keyvault | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | sku name for the keyvault | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | number of days to retain soft deleted keys | `number` | `7` | no |
| <a name="input_use_rbac"></a> [use\_rbac](#input\_use\_rbac) | whether to use RBAC for the keyvault | `bool` | `true` | no |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.45.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.80 |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | The id of the keyvault |
| <a name="output_keyvault_url"></a> [keyvault\_url](#output\_keyvault\_url) | The url of the keyvault |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | The secrets in the keyvault |


Examples:

```hcl
# policy based access control
#
# This example uses the namep provider to generate standardized resource names.
# See: https://registry.terraform.io/providers/jason-johnson/namep/latest/docs

module "keyvault" {
  source = "github.com/jason-johnson/tf-azure-keyvault?ref=v1.3.0"

  # Use namep to generate a standardized keyvault name
  name                = provider::namep::namestring("azurerm_key_vault", data.namep_configuration.main.configuration, { name = "mykv" })
  resource_group_name = "myresourcegroup"
  location            = "westeurope"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  use_rbac            = false
  managing_object_id  = data.azurerm_client_config.current.object_id
  permissions = [
    {
      name                    = "example_reader"
      object_id               = "00000000-0000-0000-0000-000000000000"
      key_permissions         = "read"
      secret_permissions      = "read"
      certificate_permissions = "read"
    },
    {
      name                    = "example_contributor"
      object_id               = "11111111-0000-0000-0000-000000000000"
      key_permissions         = "contribute"
      secret_permissions      = "contribute"
      certificate_permissions = "contribute"
    }
  ]

  secrets = [
    {
      name  = "secret1"
      value = "value1"
    },
    {
      name  = "secret2"
      value = "value2"
    }
  ]
}

# RBAC based example

resource "azurerm_service_plan" "main" {
  name                = "myplan"
  resource_group_name = "myresourcegroup"
  location            = "westeurope"
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "main" {
  name                = azurerm_service_plan.main.name
  resource_group_name = "myresourcegroup"
  location            = "westeurope"
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name = "hello:latest"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

module "keyvault_rbac" {
  source = "github.com/jason-johnson/tf-azure-keyvault?ref=v1.3.0"

  # Use namep to generate a standardized keyvault name
  name                = provider::namep::namestring("azurerm_key_vault", data.namep_configuration.main.configuration, { name = "rbkv" })
  resource_group_name = "myresourcegroup"
  location            = "westeurope"
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  use_rbac            = true
  managing_object_id  = data.azurerm_client_config.current.object_id

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  permissions = [
    {
      name                    = "myapp"
      object_id               = azurerm_linux_web_app.main.identity[0].principal_id
      key_permissions         = "read"
      secret_permissions      = "read"
      certificate_permissions = "read"
    }
  ]

  secrets = [
    {
      name  = "secret1"
      value = "value1"
    },
    {
      name  = "secret2"
      value = "value2"
    }
  ]
}
```  
<!-- END_TF_DOCS -->