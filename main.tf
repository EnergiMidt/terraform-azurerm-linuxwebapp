locals {
  name     = var.override_name == null ? "${var.system_name}-${lower(var.environment)}-app" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name

  service_plan_id = var.service_plan_id

  dynamic "site_config" {
    for_each = var.site_config
    content {
      # TODO: Implement this dynamic block.
      always_on = setting.value["always_on"] # (Optional) If this Linux Web App is Always On enabled. Defaults to `true`.
    }
  }

  app_settings = var.app_settings

  tags = var.tags
}
