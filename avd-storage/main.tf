## Create a Resource Group for Storage
resource "azurerm_resource_group" "avd-sa" {
  location = var.location
  name     = "${lower(var.prefix)}-avd-prod"
}

resource "random_string" "random" {
    length = 6
    special = false
    upper = false
}

## Azure Storage Accounts requires a globally unique names
## https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
## Create a File Storage Account 
resource "azurerm_storage_account" "avd-sa" {
  name                     = "${var.prefix}${lower(var.sa_name)}"
  # ${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.avd-sa.name
  location                 = azurerm_resource_group.avd-sa.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
  min_tls_version          = "TLS1_2"
  public_network_access_enabled = "false"
  share_properties {
    smb {
      multichannel_enabled = false
    }
  }
  tags = {
    "location" = "westeurope"
    "environment" = "prd"
  }
}

resource "azurerm_storage_share" "fslogix" {
  name                  = "fslogix"
  storage_account_name  = azurerm_storage_account.avd-sa.name
  depends_on            = [azurerm_storage_account.avd-sa]
  quota                 = "1024"
}
