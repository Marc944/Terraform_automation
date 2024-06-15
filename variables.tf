variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "managed_disk_id" {
  description = "The ID of the existing managed disk to attach"
  type        = string
}

