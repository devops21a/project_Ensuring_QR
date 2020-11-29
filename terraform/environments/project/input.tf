# Azure GUIDS
variable "subscription_id" {
  type = string
  default = "ff63d938-3ec1-4bbb-a80e-2f733dd33cf6"
}
variable "client_id" {
  type = string
  default = "dea41759-f795-41ec-b903-42587009a5c3"
}
variable "client_secret" {
  type = string
  default = "dqmPddWbtKBjznvduY65uKah~-spFpB5uW"
}
variable "tenant_id" {
  type = string
  default = "0a1a335c-1ae6-46a7-9df0-624a83a42b52"
}
# Resource Group/Location
variable "location" {
  type = string
  default = "northeurope"
}
variable "resource_group" {
  type = string
  default = "proj-appservice-grp"
}
variable "application_type" {
  type =  string
  default = "other"
}
variable address_prefix_test {
  type = string
  default = "10.5.1.0/24"
}
variable address_space {
  type = list(string)
  default = ["10.5.0.0/16"]
}

