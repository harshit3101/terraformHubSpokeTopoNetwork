# Resource group variables

variable "name" {
  type        = string
  description = "Name of resource group."
}

variable "location" {
  type        = string
  description = "The Azure region to deploy to."
}

variable "tags" {
  type        = map(any)
  description = "Mapping of tags to be assigned to Resources."
  default     = {}
}