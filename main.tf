locals {
  name     = var.override_name == null ? "${var.system_name}-${lower(var.environment)}-app" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name

  service_plan_id = var.service_plan_id
  site_config     = var.site_config
  app_settings    = var.app_settings

  tags = var.tags
}
