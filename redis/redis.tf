data "azurerm_resource_group" "resource_group" {
  name = "readit-app-rg"
}

# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = "${var.prefix}-redis-02468"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}