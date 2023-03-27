// Variables
vm_name         = "w11-22h2-1"
vm_rg           = "images-rg"
region          = "westeurope"
vnet_rg         = "vm-dc-rg"
vnet_name       = "vm-dc-rg-vnet"
subnet_name     = "default"
vm_size         = "Standard_D2as_v5"
vm_username     = "ibeerens"
tag_environment = "test"

// Windows 11 22H2 AVD version
offer     = "Windows-11"
publisher = "microsoftwindowsdesktop"
sku       = "win11-22h2-avd"
/*
// Windows server 2022
offer     = "windowsserver"
publisher = "microsoftwindowsserver"
sku       = "2022-datacenter-azure-edition"
*/

// Disk types
// Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS
vm_storage = "Standard_LRS"

// Timezone 
// Possible values: https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
vm_timezone = "W. Europe Standard Time"

file_uris = "https://raw.githubusercontent.com/ibeerens/Terraform/main/Scripts/post_install.ps1"

// VM Shutdown
vm_shutdown = "2100"