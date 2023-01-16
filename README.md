# Terraform

## Install Prereq

```
Azure CLI download https://learn.microsoft.com/en-us/cli/azure/
```

Logging in to Azure CLI https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/azure_cli
```
*az login*

*az account show*
```

##  Create a Service Principal

Create Service Principal https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
```
az ad sp create-for-rbac –name "Terraform-User-March-2021" –role "Contributor" –scope "/subscriptions/$(SubscriptionID)"
```

