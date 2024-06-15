variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                = "emiliekeyvaultrepo1"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",  # Added "Recover" permission
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Delete",
    ]
  }

  // Ensure that the Key Vault is configured for soft-delete and purge protection
  soft_delete_retention_days = 90  # Retention period for soft-deleted items
  purge_protection_enabled   = true  # Enable purge protection
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "mysecretvalue"
  key_vault_id = azurerm_key_vault.example.id
}
