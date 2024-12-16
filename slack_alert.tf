resource "azurerm_logic_app_workflow" "slack_notification" {
  name                = "logic-${var.aca-env}-slack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_logic_app_trigger_http_request" "slack" {
  name         = "slack-webhook"
  logic_app_id = azurerm_logic_app_workflow.slack_notification.id

  schema = <<SCHEMA
{
    "type": "object",
    "properties": {
        "schemaId": {"type": "string"},
        "data": {
            "type": "object",
            "properties": {
                "essentials": {
                    "type": "object",
                    "properties": {
                        "alertId": {"type": "string"},
                        "alertRule": {"type": "string"},
                        "severity": {"type": "string"},
                        "signalType": {"type": "string"},
                        "monitorCondition": {"type": "string"},
                        "monitoringService": {"type": "string"},
                        "alertTargetIDs": {"type": "array"},
                        "configurationItems": {"type": "array"},
                        "originAlertId": {"type": "string"},
                        "firedDateTime": {"type": "string"},
                        "description": {"type": "string"},
                        "essentialsVersion": {"type": "string"},
                        "alertContextVersion": {"type": "string"}
                    }
                }
            }
        }
    }
}
SCHEMA
}