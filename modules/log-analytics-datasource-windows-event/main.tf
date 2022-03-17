# Resource Group main

locals {


}


resource "azurerm_log_analytics_datasource_windows_event" "r_azurerm_log_analytics_datasource_windows_event" {
  for_each = { for item in var.log_analytics_datasource_windows_event_list : item.log_analytics_datasource_windows_event_name => item }

  name                = each.value.log_analytics_datasource_windows_event_name
  resource_group_name = var.rg_name
  workspace_name      = var.log_analytics_workspace_name
  event_log_name      = each.value.event_log_name
  event_types         = each.value.event_types
}