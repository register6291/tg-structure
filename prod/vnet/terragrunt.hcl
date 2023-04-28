terraform {
  source = "git::https://github.com/Azure/terraform-azurerm-vnet.git//examples/complete?ref=tags/3.2.0"

  before_hook "remove_versions.tf" {
    commands = ["init", "plan", "apply"]
    execute  = ["rm", "-r", "versions.tf"]
  }

}

include "root" {
  path = find_in_parent_folders()
}

locals {
  module_vars             = yamldecode(file("module.yaml"))
  environment_common_vars = yamldecode(file(find_in_parent_folders("environment_common_vars.yaml")))
}

inputs = merge(local.environment_common_vars.modules.vnet, local.module_vars.values)
