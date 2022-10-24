# [terraform-azurerm-linuxwebapp][1]

Manages a Linux Web App.

## Getting Started

- Format and validate Terraform code before commit.

```shell
terraform init -upgrade \
    && terraform init -reconfigure -upgrade \
    && terraform fmt -recursive . \
    && terraform fmt -check \
    && terraform validate .
```

- Always fetch latest changes from upstream and rebase from it. Terraform documentation will always be updated with GitHub Actions. See also [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

```shell
git fetch --all --tags --prune --prune-tags \
  && git pull --rebase --all --prune --tags
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_web_app.linux_web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) A map of key-value pairs of App Settings as defined at [azurerm\_linux\_web\_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_auth_settings"></a> [auth\_settings](#input\_auth\_settings) | (Optional) A `auth_settings` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | <pre>object(<br>    {<br>      enabled = bool # (Required) Should the Authentication / Authorization feature be enabled for the Linux Web App?<br>      active_directory = optional(object(<br>        {<br>          client_id                  = string                 # (Required) The ID of the Client to use to authenticate with Azure Active Directory.<br>          allowed_audiences          = optional(list(string)) # (Optional) Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory. Note: The `client_id` value is always considered an allowed audience.<br>          client_secret              = optional(string)       # (Optional) The Client Secret for the Client ID. Cannot be used with `client_secret_setting_name`.<br>          client_secret_setting_name = optional(string)       # (Optional) The App Setting name that contains the client secret of the Client. Cannot be used with `client_secret`.<br>        }<br>      ))                                                      # (Optional) An `active_directory` block as defined above.<br>      additional_login_parameters    = optional(map(string))  # (Optional) Specifies a map of login Parameters to send to the OpenID Connect authorization endpoint when a user logs in.<br>      allowed_external_redirect_urls = optional(list(string)) # (Optional) Specifies a list of External URLs that can be redirected to as part of logging in or logging out of the Linux Web App.<br>      default_provider               = optional(string)       # (Optional) The default authentication provider to use when multiple providers are configured. Possible values include: `BuiltInAuthenticationProviderAzureActiveDirectory`, `BuiltInAuthenticationProviderFacebook`, `BuiltInAuthenticationProviderGoogle`, `BuiltInAuthenticationProviderMicrosoftAccount`, `BuiltInAuthenticationProviderTwitter`, `BuiltInAuthenticationProviderGithub`. Note: This setting is only needed if multiple providers are configured, and the `unauthenticated_client_action` is set to "RedirectToLoginPage".<br>      facebook = optional(object(<br>        {<br>          app_id                  = string           # (Required) The App ID of the Facebook app used for login.<br>          app_secret              = optional(string) # (Optional) The App Secret of the Facebook app used for Facebook login. Cannot be specified with `app_secret_setting_name`.<br>          app_secret_setting_name = optional(string) # (Optional) The app setting name that contains the `app_secret` value used for Facebook login. Cannot be specified with `app_secret`.<br>          oauth_scopes            = optional(string) # (Optional) Specifies a list of OAuth 2.0 scopes to be requested as part of Facebook login authentication.<br>        }<br>      )) # (Optional) A `facebook` block as defined above.<br>      github = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) A `github` block as defined above.<br>      google = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) A `google` block as defined above.<br>      issuer = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) The OpenID Connect Issuer URI that represents the entity that issues access tokens for this Linux Web App. Note: When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/.<br>      microsoft = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) A `microsoft` block as defined above.<br>      runtime_version = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) The RuntimeVersion of the Authentication / Authorization feature in use for the Linux Web App.<br>      token_refresh_extension_hours = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to `72` hours.<br>      token_store_enabled = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) Should the Linux Web App durably store platform-specific security tokens that are obtained during login flows? Defaults to `false`.<br>      twitter = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) A `twitter` block as defined above.<br>      unauthenticated_client_action = optional(object(<br>        {<br><br>        }<br>      )) # (Optional) The action to take when an unauthenticated client attempts to access the app. Possible values include: `RedirectToLoginPage`, `AllowAnonymous`.<br>    }<br>  )</pre> | <pre>{<br>  "active_directory": null,<br>  "additional_login_parameters": {},<br>  "allowed_external_redirect_urls": [],<br>  "default_provider": null,<br>  "enabled": false,<br>  "facebook": null<br>}</pre> | no |
| <a name="input_backup"></a> [backup](#input\_backup) | (Optional) A `backup` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_client_affinity_enabled"></a> [client\_affinity\_enabled](#input\_client\_affinity\_enabled) | (Optional) Should Client Affinity be enabled? | `bool` | `false` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | (Optional) Should Client Certificates be enabled? | `bool` | `false` | no |
| <a name="input_client_certificate_exclusion_paths"></a> [client\_certificate\_exclusion\_paths](#input\_client\_certificate\_exclusion\_paths) | (Optional) Paths to exclude when using client certificates, separated by `;`. | `string` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The Client Certificate mode. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. This property has no effect when `client_certificate_enabled` is `false`. | `string` | `null` | no |
| <a name="input_connection_string"></a> [connection\_string](#input\_connection\_string) | (Optional) A `connection_string` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Should the Linux Web App be enabled? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The name of the environment. | `string` | n/a | yes |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | (Optional) Should the Linux Web App require HTTPS connections. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block as defined below which contains the Managed Service Identity information for this resource. | <pre>object(<br>    {<br>      type         = string                 # (Required) Specifies the type of Managed Service Identity that should be configured on this resource. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned` (to enable both).<br>      identity_ids = optional(list(string)) # (Optional) A list of User Assigned Managed Identity IDs to be assigned to this resource.<br>    }<br>  )</pre> | <pre>{<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_key_vault_reference_identity_id"></a> [key\_vault\_reference\_identity\_id](#input\_key\_vault\_reference\_identity\_id) | (Optional) The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the `identity` block. [For more information see - Access vaults with a user-assigned identity](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references#access-vaults-with-a-user-assigned-identity). | `string` | `null` | no |
| <a name="input_logs"></a> [logs](#input\_logs) | (Optional) A `logs` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_override_location"></a> [override\_location](#input\_override\_location) | (Optional) Override the location of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | (Optional) Override the name of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The resource group in which to create the resource. | `any` | n/a | yes |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Required) The ID of the Service Plan that this Linux App Service will be created in. | `string` | n/a | yes |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | (Optional) A `site_config` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | <pre>object(<br>    {<br>      always_on             = optional(bool)   # (Optional) If this Linux Web App is Always On enabled. Defaults to `true`. Note: `always_on` must be explicitly set to `false` when using `Free`, `F1`, `D1`, or `Shared` Service Plans.<br>      api_definition_url    = optional(string) # (Optional) The URL to the API Definition for this Linux Web App.<br>      api_management_api_id = optional(string) # (Optional) The API Management API ID this Linux Web App is associated with.<br>      app_command_line      = optional(string) # (Optional) The App command line to launch.<br><br>      application_stack = optional(object({<br>        docker_image        = optional(string) # (Optional) The Docker image reference, including repository host as needed.<br>        docker_image_tag    = optional(string) # (Optional) The image Tag to use. e.g. `latest`.<br>        dotnet_version      = optional(string) # (Optional) The version of .NET to use. Possible values include `3.1`, `5.0`, and `6.0`.<br>        java_server         = optional(string) # (Optional) The Java server type. Possible values include `JAVA`, `TOMCAT`, and `JBOSSEAP`. Note: `JBOSSEAP` requires a Premium Service Plan SKU to be a valid option.<br>        java_server_version = optional(string) # (Optional) The Version of the `java_server` to use.<br>        java_version        = optional(string) # (Optional) The Version of Java to use. Supported versions of Java vary depending on the `java_server` and `java_server_version`, as well as security and fixes to major versions. Please see Azure documentation for the latest information. Note: The valid version combinations for `java_version`, `java_server` and `java_server_version` can be checked from the command line via `az webapp list-runtimes --linux`.<br>        node_version        = optional(string) # (Optional) The version of Node to run. Possible values include `12-lts`, `14-lts`, and `16-lts`. This property conflicts with `java_version`. Note: 10.x versions have been/are being deprecated so may cease to work for new resources in the future and may be removed from the provider.<br>        php_version         = optional(string) # (Optional) The version of PHP to run. Possible values include `7.4`, and `8.0`. Note: versions `5.6` and `7.2` are deprecated and will be removed from the provider in a future version.<br>        python_version      = optional(string) # (Optional) The version of Python to run. Possible values include `3.7`, `3.8`, `3.9` and `3.10`.<br>        ruby_version        = optional(string) # (Optional) Te version of Ruby to run. Possible values include `2.6` and `2.7`.<br>      }))                                      # (Optional) A `application_stack` block as defined above.<br><br>      auto_heal_enabled = optional(bool) # (Optional) Should Auto heal rules be enabled? Required with `auto_heal_setting`.<br><br>      auto_heal_setting = optional(object({<br>        action = optional(object({<br>          action_type                    = string           # (Required) Predefined action to be taken to an Auto Heal trigger. Possible values include: `Recycle`.<br>          minimum_process_execution_time = optional(string) # (Optional) The minimum amount of time in `hh:mm:ss` the Linux Web App must have been running before the defined action will be run in the event of a trigger.<br>        }))                                                 # (Optional) A `action` block as defined above.<br>        trigger = optional(object(<br>          {<br>            requests = optional(object(<br>              {<br>                count    = number # (Required) The number of requests in the specified `interval` to trigger this rule.<br>                interval = string # (Required) The interval in `hh:mm:ss`.<br>              }<br>            )) # (Optional) A requests block as defined above.<br>            slow_request = optional(list(<br>              object(<br>                {<br>                  count      = number           # (Required) The number of Slow Requests in the time `interval` to trigger this rule.<br>                  interval   = string           # (Required) The time interval in the form `hh:mm:ss`.<br>                  time_taken = string           # (Required) The threshold of time passed to qualify as a Slow Request in `hh:mm:ss`.<br>                  path       = optional(string) # (Optional) The path for which this slow request rule applies.<br>                }<br>              )<br>            )) # (Optional) One or more slow_request blocks as defined above.<br>            status_code = optional(list(<br>              object(<br>                {<br>                  count             = number           # (Required) The number of occurrences of the defined `status_code` in the specified `interval` on which to trigger this rule.<br>                  interval          = string           # (Required) The time interval in the form `hh:mm:ss`.<br>                  status_code_range = string           # (Required) The status code for this rule, accepts single status codes and status code ranges. e.g. `500` or `400-499`. Possible values are integers between `101` and `599`.<br>                  path              = optional(string) # (Optional) The path to which this rule status code applies.<br>                  sub_status        = optional(string) # (Optional) The Request Sub Status of the Status Code.<br>                  win32_status      = optional(string) # (Optional) The Win32 Status Code of the Request.<br>                }<br>              )<br>            )) # (Optional) One or more status_code blocks as defined above.<br>          }<br>        )) # (Optional) A `trigger` block as defined above.<br>      }))  # (Optional) A `auto_heal_setting` block as defined above. Required with `auto_heal`.<br><br>      container_registry_managed_identity_client_id = optional(string) # (Optional) The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.<br>      container_registry_use_managed_identity       = optional(string) # (Optional) Should connections for Azure Container Registry use Managed Identity.<br><br>      cors = optional(object({<br>        allowed_origins     = list(string)   # (Required) Specifies a list of origins that should be allowed to make cross-origin calls.<br>        support_credentials = optional(bool) # (Optional) Whether CORS requests with credentials are allowed. Defaults to `false`.<br>      }))                                    # (Optional) A `cors` block as defined above.<br><br>      default_documents                 = optional(list(string)) # (Optional) Specifies a list of Default Documents for the Linux Web App.<br>      ftps_state                        = optional(string)       # (Optional) The State of FTP / FTPS service. Possible values include `AllAllowed`, `FtpsOnly`, and `Disabled`. Note: Azure defaults this value to `AllAllowed`, however, in the interests of security Terraform will default this to `Disabled` to ensure the user makes a conscious choice to enable it.<br>      health_check_path                 = optional(string)       # (Optional) The path to the Health Check.<br>      health_check_eviction_time_in_min = optional(number)       # (Optional) The amount of time in minutes that a node can be unhealthy before being removed from the load balancer. Possible values are between `2` and `10`. Only valid in conjunction with `health_check_path`.<br>      http2_enabled                     = optional(bool)         # (Optional) Should the HTTP2 be enabled?<br><br>      ip_restriction = optional(object({<br>        action = optional(string) # (Optional) The action to take. Possible values are `Allow` or `Deny`.<br>        headers = optional(object(<br>          {<br>            x_azure_fdid      = optional(list(string)) # (Optional) Specifies a list of Azure Front Door IDs.<br>            x_fd_health_probe = optional(bool)         # (Optional) Specifies if a Front Door Health Probe should be expected.<br>            x_forwarded_for   = optional(list(string)) # (Optional) Specifies a list of addresses for which matching should be applied. Omitting this value means allow any.<br>            x_forwarded_host  = optional(list(string)) # (Optional) Specifies a list of Hosts for which matching should be applied.<br>            # Note: Please see the [official Azure Documentation](https://docs.microsoft.com/azure/app-service/app-service-ip-restrictions#filter-by-http-header) for details on using header filtering.<br>          }<br>        ))                                           # (Optional) A `headers` block as defined above.<br>        ip_address                = optional(string) # (Optional) The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.<br>        name                      = optional(string) # (Optional) The name which should be used for this `ip_restriction`.<br>        priority                  = optional(string) # (Optional) The priority value of this `ip_restriction`.<br>        service_tag               = optional(string) # (Optional) The Service Tag used for this IP Restriction.<br>        virtual_network_subnet_id = optional(string) # (Optional) The Virtual Network Subnet ID used for this IP Restriction.<br>        # Note: One and only one of `ip_address`, `service_tag` or `virtual_network_subnet_id` must be specified.<br>      })) # (Optional) One or more `ip_restriction` blocks as defined above.<br><br>      load_balancing_mode      = optional(string) # (Optional) The Site load balancing. Possible values include: `WeightedRoundRobin`, `LeastRequests`, `LeastResponseTime`, `WeightedTotalTraffic`, `RequestHash`, `PerSiteRoundRobin`. Defaults to `LeastRequests` if omitted.<br>      local_mysql_enabled      = optional(bool)   # (Optional) Use Local MySQL. Defaults to `false`.<br>      managed_pipeline_mode    = optional(string) # (Optional) Managed pipeline mode. Possible values include `Integrated`, and `Classic`.<br>      minimum_tls_version      = optional(string) # (Optional) The configures the minimum version of TLS required for SSL requests. Possible values include: `1.0`, `1.1`, and  `1.2`. Defaults to `1.2`.<br>      remote_debugging_enabled = optional(bool)   # (Optional) Should Remote Debugging be enabled? Defaults to `false`.<br>      remote_debugging_version = optional(string) # (Optional) The Remote Debugging Version. Possible values include `VS2017` and `VS2019`<br><br>      scm_ip_restriction = optional(object({<br>        action = optional(string) # (Optional) The action to take. Possible values are `Allow` or `Deny`.<br>        headers = optional(object(<br>          {<br>            x_azure_fdid      = optional(list(string)) # (Optional) Specifies a list of Azure Front Door IDs.<br>            x_fd_health_probe = optional(bool)         # (Optional) Specifies if a Front Door Health Probe should be expected.<br>            x_forwarded_for   = optional(list(string)) # (Optional) Specifies a list of addresses for which matching should be applied. Omitting this value means allow any.<br>            x_forwarded_host  = optional(list(string)) # (Optional) Specifies a list of Hosts for which matching should be applied.<br>            # Note: Please see the [official Azure Documentation](https://docs.microsoft.com/azure/app-service/app-service-ip-restrictions#filter-by-http-header) for details on using header filtering.<br>          }<br>        ))                                           # (Optional) A `headers` block as defined above.<br>        ip_address                = optional(string) # (Optional) The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.<br>        name                      = optional(string) # (Optional) The name which should be used for this `ip_restriction`.<br>        priority                  = optional(string) # (Optional) The priority value of this `ip_restriction`.<br>        service_tag               = optional(string) # (Optional) The Service Tag used for this IP Restriction.<br>        virtual_network_subnet_id = optional(string) # (Optional) The Virtual Network Subnet ID used for this IP Restriction.<br>        # Note: One and only one of `ip_address`, `service_tag` or `virtual_network_subnet_id` must be specified.<br>      })) # (Optional) One or more `scm_ip_restriction` blocks as defined above.<br><br>      scm_minimum_tls_version     = optional(string) # (Optional) The configures the minimum version of TLS required for SSL requests to the SCM site Possible values include: `1.0`, `1.1`, and  `1.2`. Defaults to `1.2`.<br>      scm_use_main_ip_restriction = optional(bool)   # (Optional) Should the Linux Web App `ip_restriction` configuration be used for the SCM also.<br>      use_32_bit_worker           = optional(bool)   # (Optional) Should the Linux Web App use a 32-bit worker? Defaults to `true`.<br>      vnet_route_all_enabled      = optional(bool)   # (Optional) Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied? Defaults to `false`.<br>      websockets_enabled          = optional(bool)   # (Optional) Should Web Sockets be enabled? Defaults to `false`.<br>      worker_count                = optional(number) # (Optional) The number of Workers for this Linux App Service.<br>    }<br>  )</pre> | <pre>{<br>  "always_on": true<br>}</pre> | no |
| <a name="input_sticky_settings"></a> [sticky\_settings](#input\_sticky\_settings) | (Optional) A `sticky_settings` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | (Optional) A `storage_account` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | (Required) The systen name which should be used for this resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | (Optional) The subnet id which will be used by this Web App for [regional virtual network integration](https://docs.microsoft.com/en-us/azure/app-service/overview-vnet-integration#regional-virtual-network-integration). | `string` | `null` | no |
| <a name="input_zip_deploy_file"></a> [zip\_deploy\_file](#input\_zip\_deploy\_file) | (Optional) The local path and filename of the Zip packaged application to deploy to this Linux Web App. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_linux_web_app"></a> [azurerm\_linux\_web\_app](#output\_azurerm\_linux\_web\_app) | The Azure Linux Web App resource. |
<!-- END_TF_DOCS -->

[1]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
