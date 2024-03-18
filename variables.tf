variable "name" {
  description = "name to to be part of the keyvault name"
}

variable "resource_group_name" {
  description = "name of the resource group to put the keyvault in"  
}

variable "sku_name" {
  description = "sku name for the keyvault"
  default = "standard"  
}

variable "use_rbac" {
  description = "whether to use RBAC for the keyvault"
  default = "true"
  
}

variable "permissions" {
  description = "list of users and policies to apply to the keyvault"
  default = []
  type = list(object({
    object_id = string
    key_permissions = string
    secret_permissions = string
    certificate_permissions = string
  }))
  
}

variable "salt" {
  description = "optional salt for use in the name"
  default = ""
}

variable "location" {
  description = "default location to use if not specified"
  default = "westeurope"  
}