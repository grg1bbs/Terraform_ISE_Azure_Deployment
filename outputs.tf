
# Output to print the Azure VPN Gateway public IP
# Uncomment this section if deploying the VPN Gateway

/*
output "vpngw_public_ip" {
  value = azurerm_virtual_network_gateway.ise_vpngw.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses[0]
}
*/

