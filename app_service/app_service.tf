resource "random_integer" "tf_random" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "tf_resource_group" {
  name     = "tf-rg"
  location = "West Europe"
}

resource "azurerm_service_plan" "tf_app_service_plan" {
  name                = "tf-appserviceplan-${random_integer.tf_random.result}"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name

  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "tf_web_app" {
  name                = "tf-app-service-${random_integer.tf_random.result}"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  service_plan_id     = azurerm_service_plan.tf_app_service_plan.id

  

  site_config { 
    always_on = false
    minimum_tls_version = "1.2"
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v6.0"
    }
  }

}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "tf_sourcecontrol" {
  app_id             = azurerm_windows_web_app.tf_web_app.id
  repo_url           = "https://github.com/enes789/azure-app-service.git"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false
}