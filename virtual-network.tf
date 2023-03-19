# Create a Resource Group for all lab resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_region
}

# Create the Virtual Network
resource "azurerm_virtual_network" "virtualnet" {
  name                = "${var.env_prefix}-vnet"
  address_space       = [var.vnet_subnet]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create the subnet for the ISE node(s)
resource "azurerm_subnet" "ise_subnet" {
  name                 = "${var.env_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtualnet.name
  address_prefixes     = [var.ise_subnet]
}

# Create a route table and routes for the Internet and Virtual Network Gateway (for site-to-site VPN)
resource "azurerm_route_table" "ise_rt" {
  name                          = "${var.env_prefix}-routetable"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

# Create the route table association to the subnet
resource "azurerm_subnet_route_table_association" "subnet_ise_rt" {
  subnet_id      = azurerm_subnet.ise_subnet.id
  route_table_id = azurerm_route_table.ise_rt.id
}
