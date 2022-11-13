terraform init

# Validate the config
# teraaform validate 
terraform plan -out main.tfplan
terraform apply main.tfplan
# terraform plan -destroy -out main.destroy.tfplan
