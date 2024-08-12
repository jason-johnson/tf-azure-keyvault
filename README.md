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
| <a name="input_name"></a> [name](#input\_name) | name to to be part of the keyvault name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group to put the keyvault in | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | tenant id to use for the keyvault | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | list of users and policies to apply to the keyvault | <pre>list(object({<br>    object_id               = string<br>    key_permissions         = string<br>    secret_permissions      = string<br>    certificate_permissions = string<br>  }))</pre> | `[]` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | list of secrets to add to the keyvault | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | sku name for the keyvault | `string` | `"standard"` | no |
| <a name="input_use_rbac"></a> [use\_rbac](#input\_use\_rbac) | whether to use RBAC for the keyvault | `bool` | `true` | no |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.45.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.80 |
| <a name="requirement_namep"></a> [namep](#requirement\_namep) | >= 1.1 |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keyvalut_url"></a> [keyvalut\_url](#output\_keyvalut\_url) | The url of the keyvault |
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | The id of the keyvault |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | The secrets in the keyvault |


Examples:

```hcl
module "keyvault" {
    source = "github.com/jason-johnson/tf-azure-keyvault?ref=v1.1.0"

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
```  
<!-- END_TF_DOCS -->