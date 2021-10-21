variable "prefix" {
  description   = "Prefix that should be used for all rsources in the example"
  default       = "udacity-test"
}

variable "location" {  
  description   = "Location of the resource group"
  default = "East US"
}

variable "resource_group" {
  description = "Name of the resource group"
  default     = "udacity-azure-terraform"
  type        = string
}

variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     =  "udemy-azure-packer"
  type        = string
}

variable "packer_image_name" {
  description = "Name of vm image"
  default     =  "ubuntuImage"
  type        = string
}

variable "vm_number" {
  description = "Number of VM resources created in load balancer"
  default     = 3
  type        = number
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "Default password for admin account"
}