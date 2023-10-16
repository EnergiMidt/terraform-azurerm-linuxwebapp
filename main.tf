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
  https_only          = var.https_only

  dynamic "identity" {
    for_each = try(var.configuration.identity, null) != null ? [var.configuration.identity] : []
    content {
      type         = var.configuration.identity.type
      identity_ids = try(var.configuration.identity.identity_ids, null)
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.configuration.auth_settings_v2, null) != null ? [var.configuration.auth_settings_v2] : []
    iterator = fisk
    content {
      auth_enabled = true
      #      excluded_paths           = []
      #      forward_proxy_convention = "NoProxy"
      #      http_route_api_prefix    = null # "/.auth"
      require_authentication = true
      require_https = true
      runtime_version = "~1"
      unauthenticated_action = "Return401" # "RedirectToLoginPage"

      active_directory_v2 {
        client_id                       = try(var.configuration.auth_settings_v2.active_directory_v2.client_id, null)
        tenant_auth_endpoint            = try(var.configuration.auth_settings_v2.active_directory_v2.tenant_auth_endpoint, null)
        #        allowed_applications            = []
        #        allowed_audiences               = []
        #        allowed_groups                  = []
        #        allowed_identities              = []
        #        jwt_allowed_client_applications = []
        #        jwt_allowed_groups              = []
        #        login_parameters                = {}
        #        www_authentication_disabled     = false
      }

      #      apple_v2 {
      #        login_scopes = []
      #      }

      #      azure_static_web_app_v2 {
      #        client_id = "agreeable-water-02add0e03.3.azurestaticapps.net"
      #      }

      #      facebook_v2 {
      #        login_scopes = []
      #      }

      #      github_v2 {
      #        login_scopes = []
      #      }

      #      google_v2 {
      #        allowed_audiences = []
      #        login_scopes      = []
      #      }

      #      login {
      #        allowed_external_redirect_urls    = []
      #        cookie_expiration_convention      = "FixedTime"
      #        cookie_expiration_time            = "08:00:00"
      #        nonce_expiration_time             = "00:05:00"
      #        preserve_url_fragments_for_logins = false
      #        token_refresh_extension_time      = 72
      #        token_store_enabled               = false
      #        validate_nonce                    = true
      #      }

      #      microsoft_v2 {
      #        allowed_audiences = []
      #        login_scopes      = []
      #      }

      #      twitter_v2 {}
    }
  }

  site_config {
    always_on                                     = try(var.configuration.site_config.always_on, true)
    container_registry_managed_identity_client_id = try(var.configuration.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.configuration.site_config.container_registry_use_managed_identity, false)

    health_check_path                 = try(var.configuration.site_config.health_check_path, null)
    health_check_eviction_time_in_min = try(var.configuration.site_config.health_check_eviction_time_in_min, null)

    vnet_route_all_enabled = try(var.configuration.site_config.vnet_route_all_enabled, false)
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
      virtual_network_subnet_id
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
