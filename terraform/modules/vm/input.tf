variable "location" {
  type = string
  default = "northeurope"
}
variable "resource_group" {}
variable "subnet_id" {}
variable "public_ip_address_id" {}
variable "size" {
  type = string
  default = "Standard_B1s"
}
variable "usr" {
	type = string
	default = "adminuser"
}