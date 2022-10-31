# system-iac-template

The infrastructure as code (IaC) repository template for internal systems.

This repository contains Terraform code to manage cloud resources for <SYSTEM_NAME> system through infrastructure as code (IaC).

## Prerequisites

- [ ] Click `Use This Template` button and use the naming convention of `<SYSTEM_NAME>-iac` for these type of repositories. For example, `samsvarserklaering-iac`. Use the generated repository for the rest of the below steps.
- [ ] Rename all instances of `<SYSTEM_NAME>` strings in this repository to the name of the actual system. For example, `samsvarserklaering`
- [ ] Rename all instances of `<ENVIRONMENT_NAME>` strings in this repository to the environment name of the actual system. For example, `test`.
- [ ] Create a new environment by navigate `Settings -> Environments -> New Environment` under the GitHub repository webpage. For example, `test`.
- [ ] Obtain relevant Azure Service Principles that will be used to connect this repository to Azure.
- [ ] Insert secrets by navigate `Settings -> Secrets -> Actions -> New Repository Secret`.

  The `az ad sp create-for-rbac` [command](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-using-the-azure-cli) will output following values.

    ```json
    {
    "appId": "00000000-0000-0000-0000-000000000000",
    "displayName": "azure-cli-2017-06-05-10-41-15",
    "name": "http://azure-cli-2017-06-05-10-41-15",
    "password": "0000-0000-0000-0000-000000000000",
    "tenant": "00000000-0000-0000-0000-000000000000"
    }
    ```

    These relevant values map to the Terraform variables like so:

    - `appId` is the `client_id` defined above.
    - `password` is the `client_secret` defined above.
    - `tenant` is the `tenant_id` defined above.

  - [ ] [Create following encrypted secrets for an environment](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-an-environment) on GitHub.
  ___

  | Secret Identifier               | Description                                               | Usage                                                                         |
  | ------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------- |
  | AZURE_CREDENTIALS               | Output of `az ad sp create-for-rbac` command.             | Allow `az cli` in GitHub Actions to store Terraform state in Azure Storage.   |
  | CLIENT_ID                       | The `appId` from `az ad sp create-for-rbac` command.      | Allow Terraform to use `azurerm` provider.                                    |
  | CLIENT_SECRET                   | The `password` from `az ad sp create-for-rbac` command.   | Allow Terraform to use `azurerm` provider.                                    |
  | SUBSCRIPTION_ID                 | The subscription ID used to create the service principle. | Allow Terraform to use `azurerm` provider.                                    |
  | TENANT_ID                       | The `tenant` from `az ad sp create-for-rbac` command.     | Allow Terraform to use `azurerm` provider.                                    |

- [ ] Run [bootstrap-tfstate-storage-account.sh](bootstrap-tfstate-storage-account.sh) from this repository.
  - [ ] Replace all instances of `<TFSTATE_STORAGE_ACCOUNT_NAME>` string in this project with the generated storage account name.
  - [ ] Commit the file and push to remote.
- [ ] Update `<MAINTAINER_NAME>` and `<MAINTAINER_EMAIL>` in [main.tf](main.tf) with the actual full name and email of the person that owns this specific system.
  - [ ] Commit the file and push to remote.
- [ ] Review/modify [.github/workflows/terraform.yml](.github/workflows/terraform.yml).

  - [ ] Replace the `<APPROVER_USERNAME_1>, <APPROVER_USERNAME_2>` GitHub usernames with correct usernames.
  - [ ] Import the state of the already generated Resource Group for the system.
  - [ ] Commit the file and push to remote.  GitHub Actions will be triggered.
- [ ] Comment out the Terraform import line in [.github/workflows/terraform.yml](.github/workflows/terraform.yml) after the import state was successful as it is no longer needed.
  - [ ] Commit the file and push to remote. GitHub Actions will be triggered.
- [ ] Optional: This `Prerequisites` can be removed as it is not longer needed at this stage when Terraform state is fully managed by Azure Storage Account.

## Getting Started

- Review [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

  - This workflow can detect changes found during Terraform Plan step.
    - If changes are detected, manual approval needed under Issues tab.
      - If manual approval is being given, only then Terraform Apply can proceed.
    - If the current infrastructure matches the configuration, the workflow will skip both manual approval and Terraform Apply step.
      - This approach will reduce noise under Issues tab and save resources.

- Format and validate terraform code before commit.

```shell
terraform init -upgrade \
    && terraform init -reconfigure -upgrade \
    && terraform fmt -recursive . \
    && terraform fmt -check \
    && terraform validate .
```

- Always fetch latest changes from upstream and rebase from it. Terraform documentation will always be updated with GitHub Actions. See also [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

```shell
git fetch --all --prune --prune-tags \
  && git pull --rebase --all --prune --tags
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Optional: Links

- If GitHub Actions is not running, check [GitHub Status](https://www.githubstatus.com/).
- [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage).

## Miscellaneous

- Lint YAML file(s).

```shell
yamllint \
    --config-data "{extends: relaxed, rules: {line-length: {max: 350}}}" \
    .github/workflows/terraform.yml
```
