#!/bin/bash

RESOURCE_GROUP_NAME=proj-grp
STORAGE_ACCOUNT_NAME=storagename$RANDOM
CONTAINER_NAME=containername

# Retrieve a list of supported regions for your subscription
# az account list-locations --out table

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location northeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# List the account access keys
# az storage account keys list --resource-group proj-grp --account-name storagename29257

# Check if the container exists
# az storage container exists --account-name mystorageccount --account-key 00000000 --name mycontainer

# Create a Service Principal
# az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/ff63d938-3ec1-4bbb-a80e-2f733dd33cf6"

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"