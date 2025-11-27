variable "name" {
  description = "name to to be part of the keyvault name"
  type        = string
}

variable "namep_configuration" {
  description = "Configuration for namep provider to generate resource names. Usually created by the namep_configuration data source. If not provided, the name variable is used directly."
  type = object({
    variables     = map(string)
    variable_maps = map(map(string))
    formats       = map(string)
    types = map(object({
      name             = string
      slug             = string
      min_length       = number
      max_length       = number
      lowercase        = bool
      validation_regex = string
      default_selector = string
    }))
  })
  default = null
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

variable "purge_protection_enabled" {
  description = "whether to enable purge protection"
  default     = false
}

variable "soft_delete_retention_days" {
  description = "number of days to retain soft deleted keys"
  default     = 7
}

variable "enabled_for_disk_encryption" {
  description = "whether to enable disk encryption"
  default     = true

}

variable "use_rbac" {
  description = "whether to use RBAC for the keyvault"
  default     = true

}

variable "public_network_access_enabled" {
  description = "whether to enable public network access"
  default     = true
}

variable "network_acls" {
  description = "network ACLs to apply to the keyvault"
  default = null
  type = object({
    bypass = string
    default_action = string
    ip_rules = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
}

variable "managing_object_id" {
  description = "object id of the user who will manage the keyvault"
  type        = string
}

variable "permissions" {
  description = "list of users and policies to apply to the keyvault"
  default     = []
  type = list(object({
    name                    = string
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
