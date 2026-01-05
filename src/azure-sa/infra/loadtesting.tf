resource "azurerm_load_test" "load_test" {
  name                = "${var.app_name}-load-test"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Environment = var.environment
  }
}
