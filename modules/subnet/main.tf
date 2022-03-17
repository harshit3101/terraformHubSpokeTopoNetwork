# virtual network main

locals {
}


resource "azurerm_subnet" "subnet" {
  resource_group_name = var.rg_name
  virtual_network_name  = var.vnet_name

  for_each = var.subnets_map

  name              = each.key
  address_prefixes  = each.value

}