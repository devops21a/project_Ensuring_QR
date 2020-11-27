# Resource Group
variable location {
  type = string
  default = "northeurope"
}
variable "resource_group" {
  type = string
  default = "proj-appservice-grp"
}