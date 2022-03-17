# virtual network main

locals {

  default_tags = {
    
  }

  vnet_tags = merge(local.default_tags, var.tags)
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  address_space = var.address_space

  tags = local.vnet_tags
}