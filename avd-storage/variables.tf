variable "location" {
  description = "(Required) location where this resource has to be created"
  default = "westeurope"
}

variable "prefix" {
    description = "customer prefix"
    default = "001"
}

variable "sa_name" {
    description = "Storage Account name"
    default = "saafshot01"
}