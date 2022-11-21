output "web_url" {
  value = azurerm_windows_web_app.tf_web_app.default_hostname
}