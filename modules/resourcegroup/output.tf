#output resource group

output "rg_name" {
  value = azurerm_resource_group.r_rg.name
}

output "rg_location" {
  #exported From attribute reference
  value = azurerm_resource_group.r_rg.location
}