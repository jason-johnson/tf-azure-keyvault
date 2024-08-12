variable "name" {
  description = "name to to be part of the keyvault name"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group to put the keyvault in"
  type        = string
}

variable "location" {
  description = "default location to use if not specified"
  type        = string
}

variable "tenant_id" {
  description = "tenant id to use for the keyvault"
  type        = string
}

variable "sku_name" {
  description = "sku name for the keyvault"
  default     = "standard"
}

variable "use_rbac" {
  description = "whether to use RBAC for the keyvault"
  default     = true

}

variable "managing_object_id" {
  description = "object id of the user who will manage the keyvault"
  type        = string
}

variable "permissions" {
  description = "list of users and policies to apply to the keyvault"
  default     = []
  type = list(object({
    object_id               = string
    key_permissions         = string
    secret_permissions      = string
    certificate_permissions = string
  }))
}

variable "secrets" {
  description = "list of secrets to add to the keyvault"
  default     = []
  type = list(object({
    name  = string
    value = string
  }))
}
