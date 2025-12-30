terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # stored in backend.bk
  }
}

provider "azurerm" {
  features {}
}
