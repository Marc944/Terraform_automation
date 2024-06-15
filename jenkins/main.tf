provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "managed_disk_id" {
  description = "The ID of the existing managed disk to attach"
  type        = string
}

resource "azurerm_network_interface" "jenkins" {
  name                = "jenkins-vm763_z1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
  }
}

resource "azurerm_public_ip" "jenkins" {
  name                = "pip-main-vnet-eastus-internal"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "jenkins-vm" {
  name                  = "jenkins-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "jenkins_os_disk"
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = "/subscriptions/cac54a74-04fe-4cbf-91d0-dd16f5fd89bd/resourceGroups/EMILIE_KOUANGOUA_CANDIDATE/providers/Microsoft.Compute/disks/jenkins_os_disk"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jenkins-vm"
    admin_username = "azureuser"
    admin_password = "P@ssw0rd1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = [
    azurerm_public_ip.jenkins,
    azurerm_network_interface.jenkins
  ]
}