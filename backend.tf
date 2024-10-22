terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1" # Match the module's required version
    }

  }
  backend "azurerm" {
    resource_group_name  = "rg-backend-tf"
    storage_account_name = "terraformpokroytesting"
    container_name       = "tfstatepokroy"
    key                  = "terraformtest_new.tfstate"

  }

}

provider "azurerm" {
  features {
  }
}
provider "azapi" {
}
