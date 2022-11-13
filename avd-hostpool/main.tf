# Last Updated by: Ivo Beerens
# Date: 28-10-2022
# Version history:
# 1.0 Creation 
#   Based on: https://learn.microsoft.com/en-us/azure/developer/terraform/configure-azure-virtual-desktop
#   Terraform documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool
#   Terraform start: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build


#Create a AVD resoure group 000-avd-backplane
resource "azurerm_resource_group" "avd-backplane" {
    name                = "${var.prefix}-avd-backplane"
    location            = var.location
    tags = {
        "Environment_prod"   = "prod"
        "Environment_Acc"    = "acc"
        "Workload"           = "avd"
    }
}

#Create a AVD resoure group rg-sessionhosts
resource "azurerm_resource_group" "avd-sessionhosts" {
  name                  = "${var.prefix}-avd-session-hosts"
  location              = var.location
  tags = {
    "Location"          = "westeurope"
    "Environment"       = "prod"
  }
}

data "azurerm_resource_group" "vnet-rg" {
  name = "avd-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = "avd-vnet"
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
}

#refer to a subnet
data "azurerm_subnet" "subnet" {
  name                 = "avd-vnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet-rg.name
}

# create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.avd-sessionhosts.location
  resource_group_name = azurerm_resource_group.avd-sessionhosts.name

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = "${azurerm_public_ip.test.id}"
  }
  tags = {
    "Location"          = "westeurope"
    "Environment"       = "prod"
  }
}

#Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
    name                = "${var.prefix}-avd-workspace"
    resource_group_name = azurerm_resource_group.avd-backplane.name
    friendly_name       = "AVD Workspace Prod"
    description         = "AVD Workspace Prod"
    location            = var.location
}

#Create AVD hostpool
resource "azurerm_virtual_desktop_host_pool" "hp" {
    resource_group_name = azurerm_resource_group.avd-backplane.name
    name = "${var.prefix}-hp"
    description = "Hostpool Prod"
    friendly_name = "Hostpool Prod"
    location = azurerm_resource_group.avd-backplane.location
    validate_environment = false 
    start_vm_on_connect = false
    custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;" 
    # All the rdp properties can be found here:
    # https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/rdp-files
    type = "Pooled"
    maximum_sessions_allowed = 16
    load_balancer_type = "BreadthFirst" #[BreadthFirst DepthFirst]
    scheduled_agent_updates {
        enabled = true
        timezone = "W. Europe Standard Time"
        schedule {
            day_of_week = "Sunday"
            hour_of_day = 18
        }
        schedule {
            day_of_week = "Saturday"
            hour_of_day = 18
        }
    }
    tags = {
      "image" = "test"
      "location" = "prod"
      "environment" = "prod"
    }
}

# resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
#    hostpool_id = azurerm_virtual_desktop_host_pool.hp.id
#    expiration_date = var.rfc3339
# }

resource "time_rotating" "avd_registration_expiration" {
    rotation_days = 29
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id = azurerm_virtual_desktop_host_pool.hp.id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = azurerm_resource_group.avd-backplane.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hp.id
  location            = azurerm_resource_group.avd-backplane.location
  type                = "Desktop"
  name                = "${var.prefix}-dag"
  friendly_name       = "Desktop AppGroup"
  description         = "AVD Desktop Application Group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hp, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}

#Create scaling plan
#resource "azurerm_virtual_desktop_scaling_plan" "scalingplan" {
#    name = "${var.prefix}-avd-sp-prod"
#}

