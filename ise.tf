
# Add the SSH public key to be used for the ISE instance
resource "azurerm_ssh_public_key" "ise_sshkey" {
  name                = "${var.env_prefix}-ssh-public-key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = file("~/.ssh/ise_azure_sshkey.pub")
}

# Create a public IP for the ISE node (optional)
resource "azurerm_public_ip" "ise32_az1_public_ip" {
  name                = "ise32-az1-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}


# Create a network interface for the ISE node
resource "azurerm_network_interface" "ise32_az1_gig0" {
  name                = "ise32-az1-gig0"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ise32-az1-gig0"
    subnet_id                     = azurerm_subnet.ise_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ise32_az1_gig0_ip
    public_ip_address_id          = azurerm_public_ip.ise32_az1_public_ip.id
  }
}

# Associate the ISE network interface with the Network Security Group
resource "azurerm_network_interface_security_group_association" "ise32_az1_sg" {
  network_interface_id      = azurerm_network_interface.ise32_az1_gig0.id
  network_security_group_id = azurerm_network_security_group.ise_sg.id
}

# Create ISE VM instance
resource "azurerm_linux_virtual_machine" "ise32_az1" {
  name                = "ise32-az1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = "iseadmin"

  network_interface_ids = [azurerm_network_interface.ise32_az1_gig0.id]
  user_data             = filebase64("./ise32az1.txt")

  admin_ssh_key {
    public_key = azurerm_ssh_public_key.ise_sshkey.public_key
    username   = "iseadmin"
  }

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = var.ise_disk_size
    storage_account_type = var.ise_storage_type
  }

  plan {
    name      = "cisco-ise_3_2"
    product   = "cisco-ise-virtual"
    publisher = "cisco"
  }

  source_image_reference {
    offer     = "cisco-ise-virtual"
    publisher = "cisco"
    sku       = "cisco-ise_3_2"
    version   = "latest"
  }
}
