# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

/* TF Backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-test-shared"
    storage_account_name = "storagetfstatetest"
    container_name       = "tfstatecontainer"
    key                  = "prod.terraform.tfstate"
  }
}
*/

resource "azurerm_resource_group" "test01" {
  name     = format("rg-%s-workshop", var.environment)
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub_namespace" "test01" {
  name                = format("%s-%s", var.ehnamespacename, var.environment)
  location            = var.location
  resource_group_name = azurerm_resource_group.test01.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "test01" {
  name                = var.ehname
  namespace_name      = azurerm_eventhub_namespace.test01.name
  resource_group_name = azurerm_resource_group.test01.name
  partition_count     = 2
  message_retention   = 1
}