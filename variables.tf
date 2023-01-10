variable "environment" {
  description = "(Required) The name of the environment."
  type        = string
  validation {
    condition = contains([
      "dev",
      "test",
      "prod",
    ], var.environment)
    error_message = "Possible values are dev, test, and prod."
  }
}

variable "configuration" {
  description = "(Optional) The configuration for block type arguments."
  type        = any
  default     = null
}

# This `name` variable is replaced by the use of `system_name` and `environment` variables.
# variable "name" {
#   description = "(Required) The name which should be used for this resource. Changing this forces a new resource to be created."
#   type        = string
# }

variable "system_short_name" {
  description = <<EOT
  (Required) Short abbreviation (to-three letters) of the system name that this resource belongs to (see naming convention guidelines).
  Will be part of the final name of the deployed resource.
  EOT
  type        = string
}

variable "app_name" {
  description = <<EOT
  (Required) Name of this resource within the system it belongs to (see naming convention guidelines).
  Will be part of the final name of the deployed resource.
  EOT
  type        = string
}

variable "override_name" {
  description = "(Optional) Override the name of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "override_location" {
  description = "(Optional) Override the location of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group in which to create the resource."
  type        = any
}

# This `resource_group_name` variable is replaced by the use of `resource_group` variable.
# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

# This `location` variable is replaced by the use of `resource_group` variable.
# variable "location" {
#   description = "(Required) The location where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

variable "service_plan_id" {
  description = "(Required) The ID of the Service Plan that this Linux App Service will be created in."
  type        = string
}

variable "site_config" {
  description = "(Required) A site_config block as defined at [azurerm_linux_web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app)."
  type        = any
  default     = {}
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs of App Settings as defined at [azurerm_linux_web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app)."
  type        = map(any)
  default     = {}
}

# variable "identity" {
#   default = {
#     type = "SystemAssigned"
#   }
#   description = "(Optional) An identity block as defined below which contains the Managed Service Identity information for this resource."
#   type = object(
#     {
#       type         = string                 # (Required) Specifies the type of Managed Service Identity that should be configured on this resource. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned` (to enable both).
#       identity_ids = optional(list(string)) # (Optional) A list of User Assigned Managed Identity IDs to be assigned to this resource.
#     }
#   )
# }


variable "custom_domain" {
  description = <<EOT
  (Optional) A custom domain name / hostname. Example: "api.test.no"
  EOT
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
  type        = map(string)
}
