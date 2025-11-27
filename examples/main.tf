terraform {
  backend "local" {}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

provider "namep" {}

data "namep_azure_locations" "main" {}

data "namep_azure_caf_types" "main" {}

data "namep_configuration" "main" {
  variable_maps = data.namep_azure_locations.main.location_maps
  types         = data.namep_azure_caf_types.main.types
  formats = {
    azure_nodashes_subscription = "#{SLUG}#{TOKEN_1}#{TOKEN_2}#{LOCS[LOC]}#{NAME}#{SALT}"
    azure_dashes_subscription   = "#{SLUG}-#{TOKEN_1}-#{TOKEN_2}-#{LOCS[LOC]}-#{NAME}#{-SALT}"
  }

  variables = {
    token_1 = replace(data.azurerm_subscription.current.display_name, "-", " ")
    token_2 = ""
    loc     = "westeurope"
    salt    = ""
  }
}