locals {
  name     = var.override_name == null ? "${var.system_short_name}-${var.app_name}-${lower(var.environment)}-app" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                          = local.name
  location                      = local.location
  resource_group_name           = var.resource_group.name
  service_plan_id               = var.service_plan_id
  app_settings                  = var.app_settings
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = try(var.configuration.identity, null) != null ? [var.configuration.identity] : []
    content {
      type         = var.configuration.identity.type
      identity_ids = try(var.configuration.identity.identity_ids, null)
    }
  }

  site_config {
    always_on                                     = try(var.configuration.site_config.always_on, true)
    container_registry_managed_identity_client_id = try(var.configuration.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.configuration.site_config.container_registry_use_managed_identity, false)

    health_check_path                 = try(var.configuration.site_config.health_check_path, null)
    health_check_eviction_time_in_min = try(var.configuration.site_config.health_check_eviction_time_in_min, 2)

    vnet_route_all_enabled = try(var.configuration.site_config.vnet_route_all_enabled, false)

    ip_restriction_default_action = try(var.configuration.ip_restriction_default_action, "Allow")

    application_stack {
      docker_image_name        = try(var.configuration.site_config.application_stack.docker_image_name, "index.docker.io/nginx:mainline")
      docker_registry_url      = try(var.configuration.site_config.application_stack.docker_registry_url, "https://index.docker.io")
      docker_registry_username = try(var.configuration.site_config.application_stack.docker_registry_username, null)
      docker_registry_password = try(var.configuration.site_config.application_stack.docker_registry_password, null)
      java_version             = try(var.configuration.site_config.application_stack.java_version, null)
      dotnet_version           = try(var.configuration.site_config.application_stack.dotnet_version, null)
      python_version           = try(var.configuration.site_config.application_stack.python_version, null)
      node_version             = try(var.configuration.site_config.application_stack.node_version, null)
      go_version               = try(var.configuration.site_config.application_stack.go_version, null)
      php_version              = try(var.configuration.site_config.application_stack.php_version, null)
    }

    dynamic "ip_restriction" {
      for_each = try(var.configuration.ip_restriction, null) != null ? var.configuration.ip_restriction : []
      content {
        name       = try(ip_restriction.value.name, "")
        ip_address = ip_restriction.value.ip_address
        action     = try(ip_restriction.value.action, "Allow")
      }
    }
  }

  dynamic "logs" {
    for_each = try(var.configuration.logs, null) != null ? [var.configuration.logs] : []
    content {
      dynamic "http_logs" {
        for_each = try(var.configuration.logs.http_logs, null) != null ? [var.configuration.logs.http_logs] : []
        content {
          dynamic "file_system" {
            for_each = try(var.configuration.logs.http_logs.file_system, null) != null ? [
              var.configuration.logs.http_logs.file_system
            ] : []
            content {
              retention_in_days = var.configuration.logs.http_logs.file_system.retention_in_days
              retention_in_mb   = var.configuration.logs.http_logs.file_system.retention_in_mb
            }
          }
        }
      }
    }
  }

  # The AzureRM Terraform provider provides regional virtual network integration
  # via the standalone resource `app_service_virtual_network_swift_connection`
  # and in-line within this resource using the `virtual_network_subnet_id` property.
  # You cannot use both methods simultaneously.
  #
  # If the virtual network is set via the resource `app_service_virtual_network_swift_connection`
  # then `ignore_changes` should be used in the web app configuration.
  #
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      site_config[0].application_stack[0].docker_image_name
    ]
  }

  tags = var.tags

  # checkov:skip=CKV_AZURE_13: Ensure App Service Authentication is set on Azure App Service. https://docs.bridgecrew.io/docs/bc_azr_general_2
  # checkov:skip=CKV_AZURE_17: Ensure the web app has 'Client Certificates (Incoming client certificates)' set. https://docs.bridgecrew.io/docs/bc_azr_networking_7
  # checkov:skip=CKV_AZURE_18: Ensure that 'HTTP Version' is the latest if used to run the web app. https://docs.bridgecrew.io/docs/bc_azr_networking_8
  # checkov:skip=CKV_AZURE_63: Ensure that App service enables HTTP logging. https://docs.bridgecrew.io/docs/ensure-that-app-service-enables-http-logging
  # checkov:skip=CKV_AZURE_65: Ensure that App service enables detailed error messages. https://docs.bridgecrew.io/docs/tbdensure-that-app-service-enables-detailed-error-messages
  # checkov:skip=CKV_AZURE_66: Ensure that App service enables failed request tracing. https://docs.bridgecrew.io/docs/ensure-that-app-service-enables-failed-request-tracing
  # checkov:skip=CKV_AZURE_78: Ensure FTP deployments are disabled. https://docs.bridgecrew.io/docs/ensure-ftp-deployments-are-disabled
  # checkov:skip=CKV_AZURE_88: Ensure that app services use Azure Files. hhttps://docs.bridgecrew.io/docs/ensure-that-app-services-use-azure-files
}

# Custom domain
resource "azurerm_app_service_custom_hostname_binding" "custom_hostname" {
  count               = var.custom_domain == null ? 0 : 1
  hostname            = var.custom_domain
  app_service_name    = azurerm_linux_web_app.linux_web_app.name
  resource_group_name = var.resource_group.name
}

resource "azurerm_app_service_managed_certificate" "cert" {
  count                      = var.custom_domain == null ? 0 : 1
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_hostname[0].id
}

resource "azurerm_app_service_certificate_binding" "cert_binding" {
  count               = var.custom_domain == null ? 0 : 1
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_hostname[0].id
  certificate_id      = azurerm_app_service_managed_certificate.cert[0].id
  ssl_state           = "SniEnabled"
}
