resource "azurerm_firewall" "rg_firewall" {
  name                = var.fw_name
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                 = "configuration-${var.fw_name}"
    subnet_id            = var.fw_subnet_id
    public_ip_address_id = var.fw_pip_id
  }
}