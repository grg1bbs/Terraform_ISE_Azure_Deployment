/*
# Create a Gateway Subnet (must be named "GatewaySubnet")
resource "azurerm_subnet" "vpngw_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtualnet.name
  address_prefixes     = [var.vpngw_subnet]
}

# Create a Public IP for the VPN Gateway
resource "azurerm_public_ip" "vpngw_public_ip" {
  name                = "vpngw-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create a Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "ise_vpngw" {
  depends_on = [
    azurerm_subnet.vpngw_subnet,
    azurerm_public_ip.vpngw_public_ip
  ]
  active_active              = false
  enable_bgp                 = false
  generation                 = var.vpngw_generation
  location                   = azurerm_resource_group.rg.location
  name                       = "${var.env_prefix}-vpngw"
  private_ip_address_enabled = false
  resource_group_name        = azurerm_resource_group.rg.name
  sku                        = var.vpngw_sku
  tags                       = {}
  type                       = "Vpn"
  vpn_type                   = "RouteBased"

  ip_configuration {
    name                          = "vpngw-ipconfig"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpngw_public_ip.id
    subnet_id                     = azurerm_subnet.vpngw_subnet.id
  }
}

# Create a Local Network Gateway for On-Prem VPN headend

resource "azurerm_local_network_gateway" "home_lng" {
  name                = "home-lng"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = var.on_prem_gw_ip
  address_space       = [var.on_prem_subnet]
}

# Create an IKEv2 Connection for the Virtual Network Gateway. IPSec Policy must match the VPN headend configuration.

resource "azurerm_virtual_network_gateway_connection" "vpngw_conn" {
  depends_on = [
    azurerm_subnet.vpngw_subnet,
    azurerm_public_ip.vpngw_public_ip,
    azurerm_virtual_network_gateway.ise_vpngw
  ]
  connection_mode                = "Default"
  connection_protocol            = "IKEv2"
  enable_bgp                     = false
  express_route_gateway_bypass   = false
  local_azure_ip_address_enabled = false
  local_network_gateway_id       = azurerm_local_network_gateway.home_lng.id
  location                       = azurerm_resource_group.rg.location
  name                           = "vpngw-conn"
  resource_group_name            = azurerm_resource_group.rg.name
  shared_key                     = var.tunnel1_psk
  type                           = "IPsec"
  virtual_network_gateway_id     = azurerm_virtual_network_gateway.ise_vpngw.id

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "None"
  }
}

# Add a route for the On-Prem network pointing to the VPN Gateway
resource "azurerm_route" "ise_rt_onprem" {
  name                = "on-prem-network"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.ise_rt.name
  address_prefix      = var.on_prem_subnet
  next_hop_type       = "VirtualNetworkGateway"
}
*/