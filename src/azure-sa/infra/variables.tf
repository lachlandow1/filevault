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

variable "image_name" {
  description = "The name of the docker image repository"
  type        = string
  default     = "lachlandowfilevault"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "aks_node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "The VM size for the default node pool"
  type        = string
  default     = "Standard_B2s_v2"
}

variable "deploy_aci" {
  description = "Whether to deploy the Azure Container Instance"
  type        = bool
  default     = false
}
