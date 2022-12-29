data "azurerm_resource_group" "resource_group" {
  name = "readit-app-rg"
}

resource "azurerm_container_registry" "acr" {
  name                     = "tfreaditacr"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                      = "Basic"
#   admin_enabled            = false
#   georeplication_locations = ["East US", "West Europe"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = "${var.prefix}-aks-dns"
  kubernetes_version = "1.23.12"

  # automatic_channel_upgrade = "patch"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "test"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
#   sensitive = true
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.example.kube_config_raw

#   sensitive = true
# }