resource "azurerm_bastion_host" "example" {
  name                = var.bastion_host_name
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.pip_id
  }
}