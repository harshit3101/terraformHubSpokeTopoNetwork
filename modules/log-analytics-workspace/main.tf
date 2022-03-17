# Resource Group main

locals {


}


resource "azurerm_log_analytics_workspace" "r_log_analytics_workspace" {
  name     = var.log_analytics_workspace_name
  location = var.log_analytics_workspace_location
  
  sku = var.log_analytics_workspace_sku
  resource_group_name = var.rg_name
}