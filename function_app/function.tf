data "azurerm_resource_group" "resource_group" {
  name = "readit-app-rg"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.prefix}functionappsa"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "${var.prefix}-service-plan"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
  name                = "${var.prefix}-function-app"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id

  site_config {
    application_stack {
      dotnet_version = "6"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
    #"FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "CosmosDBConnection"       = ""
    "StorageConnectionString"  = "<Storage connection string>"
  }
}

# resource "azurerm_function_app_function" "app_function" {
#   name            = "ProcessOrderStorage"
#   function_app_id = azurerm_windows_function_app.function_app.id
#   #language        = "CSharp"

# #   file {
# #     name    = "run.csx"
# #     content = file("exampledata/run.csx")
# #   }

# #   test_data = jsonencode({
# #     "name" = "Azure"
# #   })

#   config_json = jsonencode({
#     "generatedBy" = "Microsoft.NET.Sdk.Functions.Generator-4.1.0",
#     "configurationSource" = "attributes",
#     "bindings" = [
#         {
#         "type" = "httpTrigger",
#         "methods" = [
#             "post"
#         ],
#         "authLevel" = "anonymous",
#         "name" = "req"
#         },
#         {
#         "type" = "blob",
#         "connection" = "StorageConnectionString",
#         "blobPath" = "orders",
#         "access" = 2,
#         "name" = "container"
#         }
#     ],
#     "disabled" = false,
#     "scriptFile" = "../bin/order.dll",
#     "entryPoint" = "AzureCourse.Function.EventGridFunction.Run"
#   })
# }