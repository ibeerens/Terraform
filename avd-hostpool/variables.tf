variable "prefix" {
  description = "customer prefix"
  type        = string
}

variable "location" {
  description = "Location of the Azure datacenter"
  type        = string
}

variable "rfc3339" {
  description = "Registration token expiration"
  type        = string
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
}

variable "image_publisher" {
  description = "Image Publisher"
  type        = string
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
}

variable "image_version" {
  description = "Image Version"
  type        = string
}

variable "admin_username" {
  description = "Local Admin Username"
  type        = string
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
}

# variable "subnet_id" {
#  description = "Azure Subnet ID"
#  default = ""
# }

variable "vm_name" {
  description = "Virtual Machine Name"
  type        = string
}

variable "vm_count" {
  description = "Number of Session Host VMs to create"
  type        = string
}

variable "domain" {
  description = "Domain to join"
  type        = string
}

variable "domain_user" {
  description = "Domain Join User Name"
  type        = string
}

variable "ou-path" {
  description = "OU Path"
  type        = string
}

variable "domain_password" {
  description = "Domain User Password"
  type        = string
}

variable "hostpoolname" {
  description = "Host Pool Name to Register Session Hosts"
  type        = string

}

variable "artifactslocation" {
  description = "Location of WVD Artifacts"
  type        = string
}
