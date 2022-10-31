provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

provider "azuredevops" {
  # https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs
  # The following arguments are supported in the provider block:
  #   org_service_url - (Required) This is the Azure DevOps organization url. It can also be sourced from the AZDO_ORG_SERVICE_URL environment variable.
  #   personal_access_token - (Required) This is the Azure DevOps organization personal access token. The account corresponding to the token will need "owner" privileges for this organization. It can also be sourced from the AZDO_PERSONAL_ACCESS_TOKEN environment variable.
  org_service_url = "https://dev.azure.com/energimidt-integrations/"
}

module "resourcegroup_<SYSTEM_NAME>" {
  source = "github.com/energimidt/terraform-azurerm-resourcegroup.git?ref=v0.0.1"

  environment = var.environment
  name        = var.system_name
  location    = var.location

  tags = {
    "MaintainerName"  = "<MAINTAINER_NAME>"
    "MaintainerEmail" = "<MAINTAINER_EMAIL>"
    "CreatedBy"       = "Terraform"
  }
}
