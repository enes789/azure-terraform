output "private_ip" {
  value = azurerm_network_interface.nic.private_ip_addresses
}

output "public_ip" {
  value = azurerm_public_ip.catalog_ip.ip_address
}