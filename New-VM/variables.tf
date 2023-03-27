variable "vnet_rg" {
  type        = string
  description = "Resource Group existing VNET"
}

variable "subnet_name" {
  type        = string
  description = "Existing Subnet"
}

variable "vnet_name" {
  type        = string
  description = "Existing VNET name"
}

variable "region" {
  type        = string
  description = "Azure region"
}

variable "vm_rg" {
  type        = string
  description = "Resource Group for template VMs"
}

variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "vm_username" {
  type        = string
  description = "Local User Name"
}

variable "vm_password" {
  type        = string
  description = "Local Password"
  sensitive   = true
}

variable "vm_size" {
  type        = string
  description = "VM size"
  sensitive   = true
}

variable "vm_storage" {
  type        = string
  description = "Storage type"
  sensitive   = true
}

variable "tag_environment" {
  type        = string
  description = "Tag"
}

variable "offer" {
  type        = string
  description = "Windows offer"
}

variable "publisher" {
  type        = string
  description = "Publisher"
}

variable "sku" {
  type        = string
  description = "SKU"
}

variable "vm_timezone" {
  type        = string
  description = "Timezone"
}

variable "file_uris" {
  type        = string
  description = "URL for the post installation script"
}

variable "vm_shutdown" {
  type        = string
  description = "VM shutdown time"
}