
resource "azurerm_route_table" "routetable" {
  name                          = var.rt_table
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "route-${var.rt_table}"
    address_prefix = var.address_prefix
    next_hop_type  = var.next_hop_type
    next_hop_in_ip_address = var.next_hop_in_ip_address
  }

}