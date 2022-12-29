# output "cosmosdb_container_id" {
#   value = azurerm_cosmosdb_sql_container.cosmosdb_sql_container.id
# }

# output "cosmosdb_sql_database_id" {
#   value = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.id
# }

output "cosmosdb_account_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb_account.endpoint
}

output "cosmosdb_account_connection_strings" {
  value = azurerm_cosmosdb_account.cosmosdb_account.connection_strings
  sensitive = true
}

