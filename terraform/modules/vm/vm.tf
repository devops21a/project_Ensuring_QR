resource "azurerm_network_interface" "test" {
  name                = "testproject-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "terraformprojectvm" {
  name                = "projectvm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = var.size
  admin_username      = var.usr
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = var.usr
    public_key = file("C:/Users/Acer/.ssh/id_rsa.pub")
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
