resource "azurerm_container_group" "aci" {
  name                = "${var.app_name}-aci"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.app_name}-aci"
  os_type             = "Linux"

  container {
    name   = var.app_name
    image  = "${azurerm_container_registry.acr.login_server}/${var.image_name}:latest"
    cpu    = "1.0"
    memory = "2.0"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      "AZURE_STORAGE_ACCOUNT_NAME" = azurerm_storage_account.sa.name
      "AZURE_CONTAINER_NAME"       = azurerm_storage_container.container.name
      "PORT"                       = "3000"
    }

    secure_environment_variables = {
      "AZURE_STORAGE_ACCOUNT_KEY" = azurerm_key_vault_secret.storage_key.value
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  diagnostics {
    log_analytics {
      workspace_id  = azurerm_log_analytics_workspace.law.workspace_id
      workspace_key = azurerm_log_analytics_workspace.law.primary_shared_key
    }
  }
}
