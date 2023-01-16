# Terraform

## Install Prerequisites

```
Azure CLI download
https://learn.microsoft.com/en-us/cli/azure/
```

## Logging in to Azure CLI 

```
az login

az account show
```

## Create a Service Principal

Create Service Principal https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal

```
az ad sp create-for-rbac –name "tfstateuser –role "Contributor" –scope "/subscriptions/$(SubscriptionID)"
```
