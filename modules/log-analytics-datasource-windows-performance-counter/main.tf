# Resource Group main

locals {


}


resource "azurerm_log_analytics_datasource_windows_performance_counter" "r_azurerm_log_analytics_datasource_windows_performance_counter" {
  for_each = { for item in var.log_analytics_datasource_windows_performance_counters_list : item.log_analytics_datasource_windows_performance_counter_name => item }

  name                = each.value.log_analytics_datasource_windows_performance_counter_name
  resource_group_name = var.rg_name
  workspace_name      = var.log_analytics_workspace_name
  object_name         = each.value.object_name
  instance_name       = each.value.instance_name
  counter_name        = each.value.counter_name
  interval_seconds    = each.value.interval_seconds
}