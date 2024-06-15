provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "Emilie_Kouangoua_Candidate" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Emilie_Kouangoua_Candidate.location
  resource_group_name = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "jenkins" {
  source              = "./jenkins"
  resource_group_name = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
  location            = azurerm_resource_group.Emilie_Kouangoua_Candidate.location
  subnet_id           = azurerm_subnet.internal.id
  managed_disk_id     = var.managed_disk_id
}

module "aks" {
  source              = "./aks"
  resource_group_name = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
  location            = azurerm_resource_group.Emilie_Kouangoua_Candidate.location
}

module "keyvault" {
  source              = "./keyvault"
  resource_group_name = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
  location            = azurerm_resource_group.Emilie_Kouangoua_Candidate.location
}

module "acr" {
  source              = "./acr"
  resource_group_name = azurerm_resource_group.Emilie_Kouangoua_Candidate.name
  location            = azurerm_resource_group.Emilie_Kouangoua_Candidate.location
}