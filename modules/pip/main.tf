resource "azurerm_public_ip" "rg_pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku            = var.sku
}