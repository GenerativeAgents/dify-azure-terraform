#!/bin/bash
# 使い方: ./create_backend.sh <RESOURCE_GROUP_NAME> <STORAGE_ACCOUNT_NAME>

RESOURCE_GROUP_NAME=$1
STORAGE_ACCOUNT_NAME=$2
CONTAINER_NAME=tfstate

# ストレージアカウントを作成
az storage account create --resource-group "$RESOURCE_GROUP_NAME" --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# BLOBコンテナを作成
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME