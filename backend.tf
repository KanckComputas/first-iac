terraform {
  backend "azurerm" {
    # TODO: Functions may not be called here. How to use dynamic environment?
    # resource_group_name  = "<SYSTEM_NAME>-${lower(var.environment)}"
    resource_group_name  = "<SYSTEM_NAME>-<ENVIRONMENT_NAME>"
    storage_account_name = "<TFSTATE_STORAGE_ACCOUNT_NAME>"
    container_name       = "tfstate"
    key                  = "<SYSTEM_NAME>-<ENVIRONMENT_NAME>.terraform.tfstate"
  }
}
