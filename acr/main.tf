variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

resource "azurerm_container_registry" "acr" {
  name                = "emiliecontainerrepo"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  admin_enabled       = true
}

# resource "azurerm_container_registry" "acr" {
#   name                = "myacr"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku                 = "Basic"
#   admin_enabled       = true
# }


