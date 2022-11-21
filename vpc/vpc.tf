
# Create a resource group
resource "azurerm_resource_group" "tf_resource_group" {
  name     = "${var.prefix}-rg"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "tf_vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  location            = azurerm_resource_group.tf_resource_group.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "tf_subnet_1" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.tf_resource_group.name
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}