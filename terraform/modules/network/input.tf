# Resource Group
variable resource_group {}
variable location {
  type = string
  default = "northeurope"
}
# Network
variable address_space {
  type = list(string)
  default = ["10.5.0.0/16"]
  description = "The address prefix to use for the subnet."
}
variable "application_type" {
  type =  string
  default = "other"
}
variable "resource_type" {
   type = string
   default = "vnet"
}
variable "address_prefix_test" {
  type = list(string)
  default = ["10.5.1.0/24"]
}

