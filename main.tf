# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "random_pet" "uniquifier" {
  length  = 1
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.CRResourceGroup}-${random_pet.uniquifier.id}-rg"
  location = "${var.Location}"
}

resource "azurerm_storage_account" "static_storage" {
  name                     = "cloudresume${random_pet.uniquifier.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}

#resource "azurerm_storage_blob" "static-web-storage-blob" {
#  name                   = "index.html"
#  storage_account_name   = azurerm_storage_account.static-storage.name
#  storage_container_name = "$web"
#  type                   = "Block"
#  content_type           = "text/html"
#  source_content         = "<h1>This is static content coming from the Terraform</h1>"
#}

resource "azurerm_storage_blob" "static-web-storage-blob" {
  for_each = fileset(path.module, "file_uploads/*")
 
  name                   = trimprefix(each.key, "file_uploads/")
  storage_account_name   = azurerm_storage_account.static_storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = each.key
}
