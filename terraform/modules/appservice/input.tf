# Resource Group/Location
variable "location" {}

variable "application_type" {
  type = string
  default = "other"
}
variable "resource_type" {
  type = string
  default = "app"
}
variable "resource_group" {}
