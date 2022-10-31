#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

SYSTEM_NAME="<SYSTEM_NAME>"
ENVIRONMENT_NAME="<ENVIRONMENT_NAME>"
RESOURCE_GROUP_NAME="${SYSTEM_NAME}-${ENVIRONMENT_NAME}"
TFSTATE_NAME="tfstate"

# echo "\${RESOURCE_GROUP_NAME}: ${RESOURCE_GROUP_NAME}"
# echo "\${#RESOURCE_GROUP_NAME} Length: ${#RESOURCE_GROUP_NAME}"
# echo "\${SYSTEM_NAME}: ${SYSTEM_NAME}"
# echo "\${#SYSTEM_NAME} Length: ${#SYSTEM_NAME}"
# echo "\${TFSTATE_NAME}: ${TFSTATE_NAME}"
# echo "\${#TFSTATE_NAME} Length: ${#TFSTATE_NAME}"
# echo "\${ENVIRONMENT_NAME}: ${ENVIRONMENT_NAME}"
# echo "\${#ENVIRONMENT_NAME} Length: ${#ENVIRONMENT_NAME}"

# Store Terraform state in Azure Storage Account
# https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage
# Manually create resource group.
# Manually create storage account to store tfstate file.
# Manually use the generated storage account name as terraform backend. See backend.tf file.
# Manually import Azure Resource Group Terraform state at the initial Terraform run.

az account set \
    --subscription "${AZURE_SUBSCRIPTION_ID}"

az group create \
    --name "${RESOURCE_GROUP_NAME}" \
    --location norwayeast

STORAGE_ACCOUNT_SYSTEM_NAME=$(echo "${SYSTEM_NAME}" | tr -d '-')
# echo "\${STORAGE_ACCOUNT_SYSTEM_NAME}: ${STORAGE_ACCOUNT_SYSTEM_NAME}"
if [[ "${STORAGE_ACCOUNT_SYSTEM_NAME}" =~ ^[a-z0-9]$ ]]; then
    echo "Error: Storage account system name must use numbers and lower-case letters only."
    echo "Note: Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only."
    exit 1
fi

# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_SYSTEM_NAME:0:16}${TFSTATE_NAME}"
echo "\${STORAGE_ACCOUNT_NAME}: ${STORAGE_ACCOUNT_NAME}"

az storage account create \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --name "${STORAGE_ACCOUNT_NAME}"

az storage container create \
    --name "${TFSTATE_NAME}" \
    --account-name "${STORAGE_ACCOUNT_NAME}"
