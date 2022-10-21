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
    }
  }

  app_settings = var.app_settings

  # auth_settings {}
  # backup {}

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
