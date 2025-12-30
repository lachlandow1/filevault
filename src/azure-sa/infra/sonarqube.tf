resource "azurerm_storage_share" "sonarqube_data" {
  name                 = "sonarqube-data"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 50
}

resource "azurerm_storage_share" "sonarqube_extensions" {
  name                 = "sonarqube-extensions"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 5
}

resource "azurerm_storage_share" "sonarqube_logs" {
  name                 = "sonarqube-logs"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 5
}

resource "azurerm_container_group" "sonarqube" {
  name                = "${var.app_name}-sonarqube"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.app_name}-sonarqube"
  os_type             = "Linux"

  container {
    name   = "sonarqube"
    image  = "sonarqube:lts-community"
    cpu    = "2"
    memory = "4"

    ports {
      port     = 9000
      protocol = "TCP"
    }

    volume {
      name                 = "sonarqube-data"
      mount_path           = "/opt/sonarqube/data"
      storage_account_name = azurerm_storage_account.sa.name
      storage_account_key  = azurerm_storage_account.sa.primary_access_key
      share_name           = azurerm_storage_share.sonarqube_data.name
    }

    volume {
      name                 = "sonarqube-extensions"
      mount_path           = "/opt/sonarqube/extensions"
      storage_account_name = azurerm_storage_account.sa.name
      storage_account_key  = azurerm_storage_account.sa.primary_access_key
      share_name           = azurerm_storage_share.sonarqube_extensions.name
    }

    volume {
      name                 = "sonarqube-logs"
      mount_path           = "/opt/sonarqube/logs"
      storage_account_name = azurerm_storage_account.sa.name
      storage_account_key  = azurerm_storage_account.sa.primary_access_key
      share_name           = azurerm_storage_share.sonarqube_logs.name
    }
  }

  tags = {
    environment = var.environment
  }
}
