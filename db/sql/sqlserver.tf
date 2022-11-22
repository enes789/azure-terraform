resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.prefix}-mssql-server"
  location                     = data.azurerm_resource_group.resource_group.location
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  version                      = "12.0"
  administrator_login          = "azuredb"
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"

  #   azuread_administrator {
  #     login_username = "AzureAD Admin"
  #     object_id      = "00000000-0000-0000-0000-000000000000"
  #   }

  tags = {
    environment = "test"
  }
}

# resource "azurerm_storage_account" "example" {
#   name                     = "examplesa"
#   location            = data.azurerm_resource_group.resource_group.location
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

resource "azurerm_mssql_database" "mssql_database" {
  name      = "${var.prefix}-db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"

  tags = {
    environment = "test"
  }
}

resource "azurerm_mssql_firewall_rule" "sql_firewall_rule" {
  name                = "myip"
  server_id           = azurerm_mssql_server.sql_server.id
  start_ip_address    = var.myip
  end_ip_address      = var.myip
}

resource "azurerm_mssql_virtual_network_rule" "virtual_network_rule" {
  name      = "${var.prefix}-vnet-rule"
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = data.azurerm_subnet.subnet.id
}