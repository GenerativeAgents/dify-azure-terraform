data "azurerm_container_app" "worker" {
  name                = azurerm_container_app.worker.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_cognitive_account" "openai" {
  name                = "dify-openai-service"
  location            = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "dify-openai-service"

  network_acls {
    default_action = "Deny"
    ip_rules       = [for ip in data.azurerm_container_app.worker.outbound_ip_addresses : ip]
  }
}