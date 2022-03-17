# Monitor scheduled query rules Alert main


resource "azurerm_monitor_scheduled_query_rules_alert" "r_monitor_scheduled_query_alert" {

  for_each = { for item in var.monitor_scheduled_query_alert_list : item.metric_key => item }

  name                = each.value.name
  location = var.location
  resource_group_name = var.rg_name

  action {
    action_group           = var.action.action_group
    email_subject          = lookup(var.action, "email_subject", null)
    custom_webhook_payload = lookup(var.action, "custom_webhook_payload", null)
  }

  data_source_id = var.data_source_id
  description    = lookup(each.value, "description", null)
  enabled        = lookup(each.value, "enabled", null)

  query       = <<-QUERY
  ${each.value.query}
  QUERY
  severity    = lookup(each.value, "severity", null)
  frequency   = each.value.frequency
  time_window = each.value.time_window

  trigger {
    operator  = each.value.trigger.operator
    threshold = each.value.trigger.threshold

    dynamic "metric_trigger" {
      for_each = length(keys(lookup(each.value.trigger, "metric_trigger", {}))) > 0 ? { 1 : 1 } : {}

      content {
        metric_column       = each.value.trigger.metric_trigger.metric_column
        metric_trigger_type = each.value.trigger.metric_trigger.metric_trigger_type
        operator            = each.value.trigger.metric_trigger.operator
        threshold           = each.value.trigger.metric_trigger.threshold
      }
    }

  }

}