locals {
  name     = var.override_name == null ? "${var.system_name}-${lower(var.environment)}-app" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name
  service_plan_id     = var.service_plan_id
  app_settings        = var.app_settings

  dynamic "identity" {
    for_each = lookup(var.configuration, "identity", {}) == false ? [] : [1]

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.managed_identities, null)
    }
  }

  site_config {}

  tags = var.tags
}
