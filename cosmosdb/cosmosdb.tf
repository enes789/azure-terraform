data "azurerm_resource_group" "resource_group" {
  name = "readit-app-rg"
}

# resource "random_integer" "ri" {
#   min = 10000
#   max = 99999
# }

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${var.prefix}-cosmos-db-02468"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
  offer_type          = "Standard"

  enable_free_tier = true

  consistency_policy {
    consistency_level = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix = 100
  }

  geo_location {
    location          = "westeurope"
    failover_priority = 0
    zone_redundant = false
  }

  tags = {
    "defaultExperience" = "Core (SQL)"
    "hidden-cosmos-mmspecial" = ""
  }

}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = "${var.prefix}-cosmos-sql-db"
  resource_group_name = azurerm_cosmosdb_account.cosmosdb_account.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb_sql_container" {
  name                  = "${var.prefix}-orders-container"
  resource_group_name   = azurerm_cosmosdb_account.cosmosdb_account.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosdb_account.name
  database_name         = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.name
  partition_key_path    = "/priority"
  #partition_key_version = 1
  throughput            = 400

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

  }

#   unique_key {
#     paths = ["/definition/idlong", "/definition/idshort"]
#   }
}