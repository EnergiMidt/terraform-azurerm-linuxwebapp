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
      always_on             = site_config.value.always_on
      api_definition_url    = site_config.value.api_definition_url
      api_management_api_id = site_config.value.api_management_api_id
      app_command_line      = site_config.value.app_command_line

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", {})
        content {
          docker_image        = application_stack.value.docker_image
          docker_image_tag    = application_stack.value.docker_image_tag
          dotnet_version      = application_stack.value.dotnet_version
          java_server_version = application_stack.value.java_server_version
          java_version        = application_stack.value.java_version
          node_version        = application_stack.value.node_version
          php_version         = application_stack.value.php_version
          python_version      = application_stack.value.python_version
          ruby_version        = application_stack.value.ruby_version
        }
      }

      auto_heal_enabled = site_config.value.auto_heal_enabled

      dynamic "auto_heal_setting" {
        for_each = lookup(site_config.value, "auto_heal_setting", {})

        content {
          dynamic "action" {
            for_each = lookup(auto_heal_setting.value, "action", {})
            content {
              action_type                    = action.value.action_type
              minimum_process_execution_time = action.value.minimum_process_execution_time
            }
          }

          dynamic "trigger" {
            for_each = lookup(auto_heal_setting.value, "trigger", {})

            content {
              dynamic "requests" {
                for_each = trigger.value.requests
                content {
                  count    = requests.value.count
                  interval = requests.value.interval
                }
              }

              dynamic "slow_request" {
                for_each = lookup(auto_heal_setting.value, "slow_request", [])
                content {
                  count      = slow_request.value.count
                  interval   = slow_request.value.interval
                  time_taken = slow_request.value.time_taken
                  path       = slow_request.value.path
                }
              }

              dynamic "status_code" {
                for_each = lookup(auto_heal_setting.value, "status_code", [])
                content {
                  count             = status_code.value.count
                  interval          = status_code.value.interval
                  status_code_range = status_code.value.status_code_range
                  path              = status_code.value.path
                  sub_status        = status_code.value.sub_status
                  win32_status      = status_code.value.win32_status
                }
              }
            }
          }
        }
      }

      container_registry_managed_identity_client_id = lookup(site_config.value, "container_registry_managed_identity_client_id", null)
      container_registry_use_managed_identity       = lookup(site_config.value, "container_registry_use_managed_identity", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", {})
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = cors.value.support_credentials
        }
      }

      default_documents                 = site_config.value.default_documents
      ftps_state                        = site_config.value.ftps_state
      health_check_path                 = site_config.value.health_check_path
      health_check_eviction_time_in_min = site_config.value.health_check_eviction_time_in_min
      http2_enabled                     = site_config.value.http2_enabled

      dynamic "ip_restriction" {
        for_each = lookup(site_config.value, "ip_restriction", {})
        content {
          action = ip_restriction.value.action

          dynamic "headers" {
            for_each = lookup(ip_restriction.value, "headers", {})
            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", [])
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", [])
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", [])
            }
          }

          ip_address                = ip_restriction.value.ip_address
          name                      = ip_restriction.value.name
          priority                  = ip_restriction.value.priority
          service_tag               = ip_restriction.value.service_tag
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        }
      }

      load_balancing_mode      = site_config.value.load_balancing_mode
      local_mysql_enabled      = site_config.value.local_mysql_enabled
      managed_pipeline_mode    = site_config.value.managed_pipeline_mode
      minimum_tls_version      = site_config.value.minimum_tls_version
      remote_debugging_enabled = site_config.value.remote_debugging_enabled
      remote_debugging_version = site_config.value.remote_debugging_version

      dynamic "scm_ip_restriction" {
        for_each = lookup(site_config.value, "scm_ip_restriction", {})
        content {
          action = scm_ip_restriction.value.action

          dynamic "headers" {
            for_each = lookup(scm_ip_restriction.value, "headers", {})
            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", [])
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", [])
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", [])
            }
          }

          ip_address                = scm_ip_restriction.value.ip_address
          name                      = scm_ip_restriction.value.name
          priority                  = scm_ip_restriction.value.priority
          service_tag               = scm_ip_restriction.value.service_tag
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
        }
      }

      scm_minimum_tls_version     = site_config.value.scm_minimum_tls_version
      scm_use_main_ip_restriction = site_config.value.scm_use_main_ip_restriction
      use_32_bit_worker           = site_config.value.use_32_bit_worker
      vnet_route_all_enabled      = site_config.value.vnet_route_all_enabled
      websockets_enabled          = site_config.value.websockets_enabled
      worker_count                = site_config.value.worker_count
    }
  }

  app_settings = var.app_settings

  dynamic "auth_settings" {
    for_each = var.auth_settings
    content {
      enabled = auth_settings.value.enabled

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory
        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
        }
      }

      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider

      dynamic "facebook" {
        for_each = auth_settings.value.facebook
        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github
        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google
        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      issuer = auth_settings.value.issuer

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      runtime_version               = auth_settings.value.runtime_version
      token_refresh_extension_hours = auth_settings.value.token_refresh_extension_hours
      token_store_enabled           = auth_settings.value.token_store_enabled

      dynamic "twitter" {
        for_each = auth_settings.value.twitter
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }

      unauthenticated_client_action = auth_settings.value.unauthenticated_client_action
    }
  }

  dynamic "backup" {
    for_each = var.backup
    content {
      name = backup.value.name

      dynamic "schedule" {
        for_each = backup.value.schedule
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }

      storage_account_url = backup.value.storage_account_url
      enabled             = backup.value.enabled
    }
  }

  client_affinity_enabled    = var.client_affinity_enabled
  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode
  # client_certificate_exclusion_paths = var.client_certificate_exclusion_paths # https://github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG.md#3280-october-20-2022

  # connection_string {}

  enabled    = var.enabled
  https_only = var.https_only

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.managed_identities
    }
  }

  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  # logs {}

  # storage_account {}

  # sticky_settings {}

  virtual_network_subnet_id = var.virtual_network_subnet_id
  zip_deploy_file           = var.zip_deploy_file

  tags = var.tags
}
