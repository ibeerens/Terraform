# Terraform
Terraform

# Install Pre

*Azure CLI*
https://learn.microsoft.com/en-us/cli/azure/

Logging in to Azure CLI
az login


# Create Service Principal
az ad sp create-for-rbac –name "$(Service-Principal-Name)" –role "Contributor" –scope "/subscriptions/$(SubscriptionNumber)"

az ad sp create-for-rbac –name "Terraform-User-March-2021" –role "Contributor" –scope "/subscriptions/$(SubscriptionID)"


