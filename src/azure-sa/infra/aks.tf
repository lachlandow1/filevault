resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.app_name}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.app_name}-aks"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  workload_autoscaler_profile {
    vertical_pod_autoscaler_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}
