data "azurerm_resource_group" "resource_group" {
  name = "readit-app-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = "readit-app-vnet"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
}

