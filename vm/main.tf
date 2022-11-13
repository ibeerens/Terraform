terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.29.1"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion    = true
      skip_shutdown_and_force_delete = true
    }
  }
}

resource "azurerm_resource_group" "resourcegroup" {
    name     = var.rg_name
    location = var.location
}


data "azurerm_subnet" "vmsubnet" {
  name                 = var.subname
  virtual_network_name = var.vnetname
  resource_group_name  = var.vnetrg
}

module "vm" {
  source     = "./createvm"
  rgname     = azurerm_resource_group.resourcegroup.name
  location   = azurerm_resource_group.resourcegroup.location
  vmname     = var.vmname
  size       = var.vmsize
  localadmin = "locadmin"
  adminpw    = var.adminpw
  subnetid   = data.azurerm_subnet.vmsubnet.id
  publisher  = var.publisher
}