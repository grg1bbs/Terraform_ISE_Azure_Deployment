variable "env_prefix" {
  default     = "iselab"
  description = "Prefix used for various resources (vnet, subnets, route-tables, etc)"
}
variable "resource_group_name" {
  default     = "iseRG"
  description = "Azure Resource Group name"
}
variable "azure_region" {
  default     = "australiaeast"
  description = "Azure region for deployment"
}
variable "key_name" {
  default     = "cisco-ise-key"
  description = "Name of keypair used for SSH"
}
variable "on_prem_subnet" {
  default     = "192.168.0.0/16"
  description = "CIDR for on-prem network (used for site-to-site VPN)"
}
variable "ise32_az1_gig0_ip" {
  default     = "10.32.32.10"
  description = "IP address used for the Gigabit 0 interface on the ISE node"
}
variable "ise_disk_size" {
  default     = 300
  description = "Disk size (in GB) for ISE node(s)"
}
variable "ise_storage_type" {
  default     = "StandardSSD_LRS"
  description = "Storage Account type for ISE disk"
}
variable "vnet_subnet" {
  default     = "10.32.0.0/16"
  description = "Subnet CIDR block for the Virtual Network"
}
variable "ise_subnet" {
  default     = "10.32.32.0/28"
  description = "Private Subnet CIDR block for the ISE node"
}
variable "vm_size" {
  default     = "Standard_D4s_v4"
  description = "VM size used for ISE node (Eval is used for this example)"
}

# Variables for Site-to-Site VPN
# Uncomment and configure variables as necessary if deploying the VPN gateway

/*
variable "vpngw_subnet" {
  default     = "10.32.33.0/27"
  description = "CIDR for VPN Gateway subnet"
}
variable "vpngw_generation" {
  default     = "Generation2"
  description = "Generation for VPN Gateway (performance, SLA, price, etc)"
}
variable "vpngw_sku" {
  default     = "VpnGw2"
  description = "SKU for VPN Gateway (must match the Generation type)"
}
variable "tunnel1_psk" {
  default     = "<pre-shared-key>"
  sensitive   = true
  description = "Pre-shared key for site-to-site VPN tunnel"
}
variable "on_prem_gw_ip" {
  default     = "<gateway ip>"
  description = "Public IP address for on-prem VPN headend"
}
*/
