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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.33.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_web_app.linux_web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | (Required) Name of this resource within the system it belongs to (see naming convention guidelines).<br>  Will be part of the final name of the deployed resource. | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) A map of key-value pairs of App Settings as defined at [azurerm\_linux\_web\_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `map(any)` | `{}` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (Optional) The configuration for block type arguments. | `any` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The name of the environment. | `string` | n/a | yes |
| <a name="input_override_location"></a> [override\_location](#input\_override\_location) | (Optional) Override the location of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | (Optional) Override the name of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The resource group in which to create the resource. | `any` | n/a | yes |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Required) The ID of the Service Plan that this Linux App Service will be created in. | `string` | n/a | yes |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | (Required) A site\_config block as defined at [azurerm\_linux\_web\_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app). | `any` | `{}` | no |
| <a name="input_system_short_name"></a> [system\_short\_name](#input\_system\_short\_name) | (Required) Short abbreviation (to-three letters) of the system name that this resource belongs to (see naming convention guidelines).<br>  Will be part of the final name of the deployed resource. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_linux_web_app"></a> [azurerm\_linux\_web\_app](#output\_azurerm\_linux\_web\_app) | The Azure Linux Web App resource. |
<!-- END_TF_DOCS -->

[1]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
