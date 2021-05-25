resource "azurerm_resource_group" "resource_group" {
  name     = "azure-devops-test-rg"
  location = "westus"
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "azure-devops-virtual-network"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "azure-devops-public-ip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "azure_bastion" {
  name                = "devopsBastion"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

