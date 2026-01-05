output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_container_name" {
  value = azurerm_storage_container.container.name
}

output "aci_fqdn" {
  value = length(azurerm_container_group.aci) > 0 ? azurerm_container_group.aci[0].fqdn : null
}

output "aci_ip_address" {
  value = length(azurerm_container_group.aci) > 0 ? azurerm_container_group.aci[0].ip_address : null
}

output "container_registry_name" {
  value = azurerm_container_registry.acr.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "container_registry_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "container_registry_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "sonarqube_ip_address" {
  value = azurerm_container_group.sonarqube.ip_address
}

output "sonarqube_fqdn" {
  value = azurerm_container_group.sonarqube.fqdn
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
