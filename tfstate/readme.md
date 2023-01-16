# Open Cloud Shell in the Azure Portal and select PowerShell

# Variables
$resourceGroup ="rg-tfstate"
$location ="westeurope"
$storageAccount ="tfstateibeerens"
$containername = "tfstate"
$serviceprincipalname = "tfstate"

# Create Resource Group
az group create -n $resourceGroup -l $location
 
# Create Storage Account
az storage account create -n $storageAccount -g $resourceGroup -l $location --sku Standard_LRS

# Create Container
 az storage container create -n $containername --account-name $storageAccount --public-access off

# Create Service Principal 
az ad sp create-for-rbac --name $serviceprincipalname


terraform {
  backend "azurerm" {
    resource_group_name   = "rg-tfstate"
    storage_account_name  = "tfstateibeerens"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
