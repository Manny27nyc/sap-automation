resource "azurerm_storage_account" "install" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                      = replace(lower(format("%s%s", local.prefix, local.resource_suffixes.install_volume)), "/[^a-z0-9]/", "")
  resource_group_name       = local.rg_exists ? data.azurerm_resource_group.resource_group[0].name : azurerm_resource_group.resource_group[0].name
  location                  = var.infrastructure.region
  account_tier              = "Premium"
  account_replication_type  = "ZRS"
  account_kind              = "FileStorage"
  enable_https_traffic_only = false


  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = compact([var.landscape_tfstate.app_subnet_id, var.landscape_tfstate.db_subnet_id, try(var.landscape_tfstate.web_subnet_id, ""), try(var.landscape_tfstate.subnet_mgmt_id, "")])
    bypass                     = ["AzureServices", "Logging", "Metrics"]
  }
}

resource "azurerm_storage_share" "install" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                 = format("%s", local.resource_suffixes.install_volume)
  storage_account_name = azurerm_storage_account.install[0].name
  enabled_protocol     = "NFS"

  quota = 128
}

resource "azurerm_storage_account" "sapmnt" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                      = replace(lower(format("%s%s", local.prefix, local.resource_suffixes.sapmnt)), "/[^a-z0-9]/", "")
  resource_group_name       = local.rg_exists ? data.azurerm_resource_group.resource_group[0].name : azurerm_resource_group.resource_group[0].name
  location                  = var.infrastructure.region
  account_tier              = "Premium"
  account_replication_type  = "ZRS"
  account_kind              = "FileStorage"
  enable_https_traffic_only = false


  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = compact([var.landscape_tfstate.app_subnet_id, var.landscape_tfstate.db_subnet_id, try(var.landscape_tfstate.web_subnet_id, ""), try(var.landscape_tfstate.subnet_mgmt_id, "")])
    bypass                     = ["AzureServices", "Logging", "Metrics"]
  }
}

resource "azurerm_storage_share" "sapmnt" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                 = format("%s", local.resource_suffixes.sapmnt)
  storage_account_name = azurerm_storage_account.sapmnt[0].name
  enabled_protocol     = "NFS"

  quota = var.sapmnt_volume_size
}

resource "azurerm_storage_account" "transport" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                      = replace(lower(format("%s%s", local.prefix, local.resource_suffixes.transport_volume)), "/[^a-z0-9]/", "")
  resource_group_name       = local.rg_exists ? data.azurerm_resource_group.resource_group[0].name : azurerm_resource_group.resource_group[0].name
  location                  = var.infrastructure.region
  account_tier              = "Premium"
  account_replication_type  = "ZRS"
  account_kind              = "FileStorage"
  enable_https_traffic_only = false


  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = compact([var.landscape_tfstate.app_subnet_id, var.landscape_tfstate.db_subnet_id, try(var.landscape_tfstate.web_subnet_id, ""), try(var.landscape_tfstate.subnet_mgmt_id, "")])
    bypass                     = ["AzureServices", "Logging", "Metrics"]
  }
}

resource "azurerm_storage_share" "transport" {
  count = var.NFS_provider == "AFS" ? 1 : 0

  name                 = format("%s", local.resource_suffixes.transport_volume)
  storage_account_name = azurerm_storage_account.transport[0].name
  enabled_protocol     = "NFS"

  quota = var.transport_volume_size
}
