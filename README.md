# Terraform

## Step 1. Download Terraform
https://developer.hashicorp.com/terraform/downloads

## Step 2. Install Azure CLI
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

Download and Install the Azure CLI with PowerShell
```
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
```
## Step 3. Login to Azure
```
az config set core.allow_broker=true
az account clear
az login
```

## Step 4. Create a Service Principal (Optional)
Create Service Principal https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
```
az ad sp create-for-rbac –name "tfstateuser –role "Contributor" –scope "/subscriptions/$(SubscriptionID)"
```
