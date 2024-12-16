#!/bin/bash

# 使い方: ./create_sshkey.sh <リソースグループ名> <ストレージアカウント名>

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
CONTAINER_NAME="ssh-keys"
KEY_NAME="ps_backup_sshkey"
LOCATION="japaneast"

if ! az group show --name "$RESOURCE_GROUP" >/dev/null 2>&1; then
    echo "Create Resource group: $RESOURCE_GROUP"
    az group create --name "$RESOURCE_GROUP" --location $LOCATION
fi

if ! az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" >/dev/null 2>&1; then
    echo "Create Storage Account: $STORAGE_ACCOUNT"
    az storage account create \
        --name "$STORAGE_ACCOUNT" \
        --resource-group "$RESOURCE_GROUP" \
        --location $LOCATION \
        --sku Standard_LRS \
        --encryption-services blob
fi

STORAGE_KEY=$(az storage account keys list \
    --resource-group "$RESOURCE_GROUP" \
    --account-name "$STORAGE_ACCOUNT" \
    --query '[0].value' -o tsv)

echo "Create SSH key pair"
ssh-keygen -t rsa -b 4096 -f ./${KEY_NAME} -N ""

if ! az storage container show --name $CONTAINER_NAME \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY" >/dev/null 2>&1; then
    echo "Blobコンテナを作成します: $CONTAINER_NAME"
    az storage container create \
        --name $CONTAINER_NAME \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$STORAGE_KEY"
fi

echo "Upload private key"
az storage blob upload \
    --container-name $CONTAINER_NAME \
    --file ./${KEY_NAME} \
    --name ${KEY_NAME} \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY"

echo "Upload public key"
az storage blob upload \
    --container-name $CONTAINER_NAME \
    --file ./${KEY_NAME}.pub \
    --name ${KEY_NAME}.pub \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY"

echo "Remove local SSH key files"
rm ./${KEY_NAME}
rm ./${KEY_NAME}.pub

echo "SSH keys have been uploaded to the storage account"