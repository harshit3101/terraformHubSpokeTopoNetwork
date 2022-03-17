# Resource Group main

locals {

  default_tags = {
  
  }

  rg_tags = merge(local.default_tags, var.tags)
}


resource "azurerm_resource_group" "r_rg" {
  name     = var.name
  location = var.location

  tags = local.rg_tags
}