provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "storagename29257"
    container_name       = "containername"
    key                  = "terraform.tfvars"
    access_key           = "KCbw4sfs9iyx7K6N7yptbA15tUaTbYRrRcPYkZd5f2kEW8uP4NXxnoMbB8kH9ghO0F+/Twj0nQRl1mKESAbPvw=="
  }
}
module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = var.resource_group
  location             = var.location
}
module "network" {
  source               = "../../modules/network"
  address_space        = var.address_space
  location             = var.location
  application_type     = var.application_type
  resource_type        = "NET"
  resource_group       = module.resource_group.resource_group_name
}
module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = var.location
  application_type = var.application_type
  resource_type    = "nsg"
  resource_group   = module.resource_group.resource_group_name
  subnet_id        = module.network.subnet_id_test
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = var.location
  application_type = var.application_type
  resource_type    = "app"
  resource_group   = module.resource_group.resource_group_name
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = var.location
  application_type = var.application_type
  resource_type    = "pip"
  resource_group   = module.resource_group.resource_group_name
}
module "vm" {
  source                    = "../../modules/vm"
  location                  = var.location
  resource_group            = module.resource_group.resource_group_name
  subnet_id                 = module.network.subnet_id_test
  public_ip_address_id      = module.publicip.public_ip_address_id
}