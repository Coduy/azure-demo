data "azurerm_resource_group" "rg" {
  name = "rg-pokroy-demo-tf-06"
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}
output "module" {
    value = module.sg_github.storage_account_name
}



# Create a storage account inside the resource group fetched by the data source
resource "azurerm_storage_account" "sg" {
  name                     = "storagepawelk0232" # Ensure this name is globally unique
  resource_group_name       = data.azurerm_resource_group.rg.name  # Use the name from the data source
  location                  = data.azurerm_resource_group.rg.location  # Use the location of the RG
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  tags = local.tags
}

module "sg_github" {
    source = "github.com/Coduy/azurerm-modules//modules/storage?ref=main"
    storage_account_name = "ohyea"
    resource_group_name = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
    fileshare_name = "vamosfileshare"
}

module "vnet" {
    source = "github.com/Coduy/azurerm-modules//modules/network?ref=main"    
    vnet_name = "my-vnet"
    address_space = ["10.0.0.0/16"]
    location = data.azurerm_resource_group.rg.location
    resource_group_name       = data.azurerm_resource_group.rg.name
}

module "subnet"{
    source = "github.com/Coduy/azurerm-modules//modules/subnet?ref=main"
    subnet_name = "my-subnet"
    virtual_network_name = module.vnet.vnet_name
    subnet_prefixes = ["10.0.10.0/24"]
    resource_group_name = data.azurerm_resource_group.rg.name  
}


resource "azurerm_public_ip" "app_gateway_ip" {
  name                = "appgw-ip"
  location            = "NorthEurope"  # Change this to your desired location
  resource_group_name = data.azurerm_resource_group.rg.name  # Your resource group name
  sku                 = "Standard"  # Can be "Basic" or "Standard"
  allocation_method   = "Static"    # Can also be "Dynamic"
}


module "appgw_github" {
    source = "github.com/Coduy/azurerm-modules//modules/app_gateway?ref=main"
    name = "appgw-01"
    resource_group_name = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
    sku_capacity = "1"
    subnet_id = module.subnet.subnet_id

    public_ip_address_id = azurerm_public_ip.app_gateway_ip.id
    cookie_based_affinity       = "Enabled"

    backend_ip_address = ""

}

resource "azurerm_resource_group" "rg_aks" {
    name = "rg-pokroy-demoaks"
    location = "NorthEurope"
}


resource "azurerm_storage_account" "sg2" {  
  name                     = local.storage.account_name
  resource_group_name       = data.azurerm_resource_group.rg.name  # Use the name from the data source
  location                  = data.azurerm_resource_group.rg.location  # Use the location of the RG
  account_tier              = local.storage.account_tier
  account_replication_type  = local.storage.replication_type
  tags = local.tags  
}



