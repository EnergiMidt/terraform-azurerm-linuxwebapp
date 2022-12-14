locals {
  name     = var.override_name == null ? "${var.system_short_name}-${var.app_name}-${lower(var.environment)}-app" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name
  service_plan_id     = var.service_plan_id
  app_settings        = var.app_settings

  dynamic "identity" {
    for_each = try(var.configuration.identity, null) != null ? [var.configuration.identity] : []
    content {
      type         = var.configuration.identity.type
      identity_ids = try(var.configuration.identity.identity_ids, null)
    }
  }

  site_config {
    container_registry_managed_identity_client_id = lookup(var.configuration.site_config, "container_registry_managed_identity_client_id", null)
    container_registry_use_managed_identity       = lookup(var.configuration.site_config, "container_registry_use_managed_identity", null)
  }

  tags = var.tags
}

# Custom domain
resource "azurerm_app_service_custom_hostname_binding" "custom_hostname" {
  count               = var.custom_domain == null ? 0 : 1
  hostname            = var.custom_domain
  app_service_name    = azurerm_linux_web_app.linux_web_app.name
  resource_group_name = var.resource_group.name
}
