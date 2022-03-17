# Virtual network variables

variable "name" {
  type        = string
  description = "Name of Virutal network."
}

variable "rg_name" {
  type        = string
  description = "Name of Resource group."
}

variable "location" {
  type        = string
  description = "The Azure region to deploy to. Recommended to use RG location."
}


variable "tags" {
  type        = map(any)
  description = "Mapping of tags to be assigned to Resources."
  default     = {}
}

variable "address_space" {
  type        = list(string)
  description = "IPv4 address space (CIDR) list for the virtual network. [\"10.0.0.0/16\"] is Default."
  default     = ["10.0.0.0/16"]
}