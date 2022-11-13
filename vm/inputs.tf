# Subnet Vars
variable "subname" {
  type = string
  description = "The name of the existing subnet"
}

variable "vnetname" {
  type = string
  description = "The name of the existing vnet"
}

variable "vnetrg" {
  type = string
  description = "The name of the VNet Resource Group"
}

# Password
variable "adminpw" {
  type = string
  sensitive = true
  description = "the local admin password, must be 12 char or longer"
}

variable "rg_name" {
    type = string
    description = "Resource group name" 
}

variable "location" {
    type = string
    default = "The region the resource is created"
}


variable "vmname" {
    type = string
    description = "Virtual Machine name"
}

variable "vmsize" {
    type = string
    default = "VM SKU"  
}

variable publisher {
  type = string
  description = "VM publisher"
}