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
      # TODO: Implement the entire block.
      always_on             = site_config.value["always_on"]             # (Optional) If this Linux Web App is Always On enabled. Defaults to `true`.
      api_definition_url    = site_config.value["api_definition_url"]    # (Optional) The URL to the API Definition for this Linux Web App.
      api_management_api_id = site_config.value["api_management_api_id"] # (Optional) The API Management API ID this Linux Web App is associated with.
      app_command_line      = site_config.value["app_command_line"]      # (Optional) The App command line to launch.
    }
  }

  app_settings = var.app_settings

  tags = var.tags
}
