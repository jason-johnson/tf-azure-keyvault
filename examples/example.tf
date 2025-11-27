# policy based access control

module "keyvault" {
  source = "./.."

  name                = "mykv"
  namep_configuration = data.namep_configuration.main.configuration
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
  source = "./.."

  name                = "rbkv"
  namep_configuration = data.namep_configuration.main.configuration
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
