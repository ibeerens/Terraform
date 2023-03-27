/*
  List external IP
  Some services for getting the public IP are:
    https://ipv4.icanhazip.com 
    https://api.ipify.org 
    https://ifconfig.co/ip
*/

data "http" "public_ip" {
  url = "https://api.ipify.org"
}

locals {
  // Clean and set the public IP address
  public_ip = chomp(data.http.public_ip.response_body)

  // use public IP with /32 
  authorized_ip_range = ["${local.public_ip}/32"]
}

data "azurerm_resource_group" "vm-rg" {
  name = var.vm_rg
}

data "azurerm_resource_group" "vnet-rg" {
  name = var.vnet_rg
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet-rg.name
}

resource "azurerm_network_interface" "netinterface" {
  name                = "${var.vm_name}-nic"
  location            = var.region
  resource_group_name = var.vnet_rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    // Not needed when using a VPN or Bastion 
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm_public_ip"
  resource_group_name = data.azurerm_resource_group.vm-rg.name
  location            = data.azurerm_resource_group.vm-rg.location
  allocation_method   = "Dynamic"
}

// NSG
resource "azurerm_network_security_group" "vm-nsg" {
  name                = "vm-nsg"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.vm-rg.name
}


// Not needed when using a VPN or Bastion
// NSG Security RDP rule(s)
resource "azurerm_network_security_rule" "vm-sec-rule" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = azurerm_network_security_group.vm-nsg.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = data.azurerm_resource_group.vm-rg.name
  source_address_prefixes     = local.authorized_ip_range
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.vm-nsg,
  ]
}

// Connect security group to NIC
resource "azurerm_network_interface_security_group_association" "nsg-connect" {
  network_interface_id      = azurerm_network_interface.netinterface.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
}

// Create VM
resource "azurerm_windows_virtual_machine" "vm" {
  admin_username = var.vm_username
  admin_password = var.vm_password
  location       = var.region
  name           = var.vm_name
  network_interface_ids = [
    azurerm_network_interface.netinterface.id
  ]
  resource_group_name = var.vm_rg
  secure_boot_enabled = true
  size                = var.vm_size
  tags = {
    Environment = var.tag_environment
  }
  timezone     = var.vm_timezone
  vtpm_enabled = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage
  }

  source_image_reference {
    offer     = var.offer
    publisher = var.publisher
    sku       = var.sku
    version   = "latest"
  }
}

// https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
resource "azurerm_virtual_machine_extension" "vmextension" {
  name                       = "post_install"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = "true"

  protected_settings = <<PROTECTED_SETTINGS
    {
       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file post_install.ps1 -EnableCredSSP -DisableBasicAuth"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
      "fileUris": [
        "${var.file_uris}"
        ]
    }
  SETTINGS
}

// Shutdown the VM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vmshutdown" {
  daily_recurrence_time = var.vm_shutdown
  location              = var.region
  timezone              = var.vm_timezone
  virtual_machine_id    = azurerm_windows_virtual_machine.vm.id
  notification_settings {
    enabled = false
  }
  depends_on = [
    azurerm_windows_virtual_machine.vm,
  ]
}

output "private_ip" {
  value = azurerm_network_interface.netinterface.private_ip_address
}

output "public_ip" {
  value = azurerm_windows_virtual_machine.vm.public_ip_address
}