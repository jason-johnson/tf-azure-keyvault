variable "name" {
  description = "name to to be part of the keyvault name"
}

variable "resource_group_name" {
  
}

variable "salt" {
  description = "optional salt for use in the name"
  default = ""
}

variable "location" {
  description = "default location to use if not specified"
  default = "westeurope"  
}