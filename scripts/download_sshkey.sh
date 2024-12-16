#!/bin/bash

# 使い方: ./download_sshkey.sh <リソースグループ名> <ストレージアカウント名>

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
CONTAINER_NAME="ssh-keys"
KEY_NAME="ps_backup_sshkey"
DOWNLOAD_DIR="./ssh_keys"

STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' -o tsv)

mkdir -p $DOWNLOAD_DIR

az storage blob download \
  --container-name $CONTAINER_NAME \
  --name ${KEY_NAME} \
  --file ${DOWNLOAD_DIR}/${KEY_NAME} \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY"

az storage blob download \
  --container-name $CONTAINER_NAME \
  --name ${KEY_NAME}.pub \
  --file ${DOWNLOAD_DIR}/${KEY_NAME}.pub \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY"

chmod 600 ${DOWNLOAD_DIR}/${KEY_NAME}
chmod 644 ${DOWNLOAD_DIR}/${KEY_NAME}.pub

echo "SSH keys have been downloaded to ${DOWNLOAD_DIR}"