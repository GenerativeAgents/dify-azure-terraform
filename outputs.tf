output "dify-app-url" {
  value = azurerm_container_app.nginx.latest_revision_fqdn
}

output "redis_cache_hostname" {
  value = var.is_aca_enabled ? azurerm_redis_cache.redis[0].hostname : ""
}

output "redis_cache_key" {
  value = var.is_aca_enabled ? azurerm_redis_cache.redis[0].primary_access_key : ""
  sensitive = true
}
