# This is the main configuration that uses modules

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
}

# Storage Account with potential security issues
resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${var.environment}sa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security issue: HTTP traffic allowed
  enable_https_traffic_only = false
  
  # Security issue: No network restrictions
  network_rules {
    default_action = "Allow"
  }
  
  # Security issue: Blob public access enabled
  allow_nested_items_to_be_public = true
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet without NSG (security issue)
resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Key Vault with potential issues
resource "azurerm_key_vault" "main" {
  name                = "${var.project_name}-${var.environment}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  
  # Security issue: No network ACLs
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
  
  # Security issue: Purge protection disabled
  purge_protection_enabled = false
}

# SQL Server with security issues
resource "azurerm_mssql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  
  # Security issue: Public endpoint enabled
  public_network_access_enabled = true
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name      = "${var.project_name}-${var.environment}-db"
  server_id = azurerm_mssql_server.main.id
  sku_name  = "Basic"
  
  # Security issue: No transparent data encryption
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# App Service with security issues
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-${var.environment}-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  
  # Security issue: HTTP allowed
  https_only = false
  
  site_config {
    # Security issue: Old TLS version
    minimum_tls_version = "1.0"
    
    # Security issue: No health check
  }
  
  # Security issue: No identity assigned
}

data "azurerm_client_config" "current" {}
