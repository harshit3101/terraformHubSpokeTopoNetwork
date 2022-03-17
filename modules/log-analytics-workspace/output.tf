#output 

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.r_log_analytics_workspace.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.r_log_analytics_workspace.name
}

