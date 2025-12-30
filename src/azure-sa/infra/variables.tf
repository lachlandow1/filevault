variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "UK West"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "filevault-rg"
}

variable "app_name" {
  description = "A base name for the application resources"
  type        = string
  default     = "filevault-sa"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}
