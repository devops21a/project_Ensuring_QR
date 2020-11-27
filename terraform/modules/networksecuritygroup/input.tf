# Resource Group/Location
variable "location" {
  type = string
  default = "northeurope"
}
variable "application_type" {
  type =  string
  default = "other"
}
variable "resource_type" {
  type = string
  default = "nsg"
}
variable "resource_group" {}
variable "subnet_id" {}


