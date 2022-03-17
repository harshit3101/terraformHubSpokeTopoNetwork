output "fw_ip_configuration" {
    value = azurerm_firewall.rg_firewall.ip_configuration
}

output "fw_virtual_hub" {
    value = azurerm_firewall.rg_firewall.virtual_hub 
}

