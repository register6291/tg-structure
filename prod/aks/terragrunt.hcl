terraform {
  source = "git::https://github.com/register6291/aks-wif.git?ref=main"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    test_vnet_id = "mock_vnet_id"
  }

  mock_outputs_allowed_terraform_commands = ["init","apply", "plan", "destroy", "output"]
}

locals {
  module_vars             = yamldecode(file("module.yaml"))
  environment_common_vars = yamldecode(file(find_in_parent_folders("environment_common_vars.yaml")))
}


inputs = merge(local.environment_common_vars.modules.aks, local.module_vars.values, { test_vnet_id = dependency.vnet.outputs.test_vnet_id })
skip   = local.environment_common_vars.modules.aks.skip