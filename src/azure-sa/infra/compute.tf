resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-web-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    "AZURE_STORAGE_ACCOUNT_NAME" = azurerm_storage_account.sa.name
    "AZURE_STORAGE_ACCOUNT_KEY"  = azurerm_storage_account.sa.primary_access_key
    "AZURE_CONTAINER_NAME"       = azurerm_storage_container.container.name
    "PORT"                       = "8080" # App Service expects 8080 usually, or we can use WEBSITES_PORT
  }
}
