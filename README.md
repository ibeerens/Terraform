# Terraform

## Download Terraform
https://developer.hashicorp.com/terraform/downloads

## Install Azure CLI
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

Download and Install the Azure CLI with PowerShell

$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi

```
## Logging in to Azure CLI 

```
az account clear
az login

az account show
```

## Create a Service Principal
Create Service Principal https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal

```
az ad sp create-for-rbac –name "tfstateuser –role "Contributor" –scope "/subscriptions/$(SubscriptionID)"
```
