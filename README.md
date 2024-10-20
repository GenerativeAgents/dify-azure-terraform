## dify-azure-terraform
Deploy [langgenius/dify](https://github.com/langgenius/dify), an LLM based chat bot app on Azure with terraform.

## 使い方

### 事前準備

1. `terraform.tfvars` ファイルを作成し、以下の内容を記述します。
- `subscription-id` : AzureサブスクリプションID
- `resource_group` : 作成するリソースグループ名（あらかじめリソースグループは作成ください）
- `web_ip_security_restrictions` : WebアプリケーションのIP制限設定（複数指定可能）

```bash
subscription-id = "xxxx"
resource_group = "xxxxxxx"
web_ip_security_restrictions = [
  {
    name = "home1"
    description = "Home IP1"
    ip_address_range = "12.12.12.12/32"
  },
  {
    name = "home2"
    description = "Home IP2"
    ip_address_range = "12.12.12.13/32"
  }
]
```

2. Azure CLIでログインします。

```bash
az login
```

3. Azure Blob Storageを作成し、Terraformのstateファイルを保存するためのコンテナを作成します。

```bash
sh scripts/create_backend.sh <リソースグループ名> <ストレージアカウント名>
```

### Terraformコマンド

```
terraform init \
  -backend-config="resource_group_name=<リソースグループ名>" \
  -backend-config="storage_account_name=<ストレージアカウント名>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=terraform.tfstate"
terraform plan
terraform apply
```

### Topology
Front-end access:
- nginx -> Azure Container Apps (Serverless)

Back-end components:
- web -> Azure Container Apps (Serverless)
- api -> Azure Container Apps (Serverless)
- worker -> Azure Container Apps (minimum of 1 instance)
- sandbox -> Azure Container Apps (Serverless)
- ssrf_proxy -> Azure Container Apps (Serverless)
- db -> Azure Database for PostgreSQL
- vectordb -> Azure Database for PostgreSQL
- redis -> Azure Cache for Redis

Before you provision Dify, please check and set the variables in var.tf file.

### Terraform Variables Documentation

This document provides detailed descriptions of the variables used in the Terraform configuration for setting up the Dify environment.

#### Subscription ID

- **Variable Name**: `subscription-id`
- **Type**: `string`
- **Default Value**: `0000000000000`

#### Virtual Network Variables

##### Region

- **Variable Name**: `region`
- **Type**: `string`
- **Default Value**: `japaneast`

##### VNET Address IP Prefix

- **Variable Name**: `ip-prefix`
- **Type**: `string`
- **Default Value**: `10.99`

#### Storage Account

- **Variable Name**: `storage-account`
- **Type**: `string`
- **Default Value**: `acadifytest`

##### Storage Account Container

- **Variable Name**: `storage-account-container`
- **Type**: `string`
- **Default Value**: `dfy`

#### Redis

- **Variable Name**: `redis`
- **Type**: `string`
- **Default Value**: `acadifyredis`

#### PostgreSQL Flexible Server

- **Variable Name**: `psql-flexible`
- **Type**: `string`
- **Default Value**: `acadifypsql`

##### PostgreSQL User

- **Variable Name**: `pgsql-user`
- **Type**: `string`
- **Default Value**: `user`

##### PostgreSQL Password

- **Variable Name**: `pgsql-password`
- **Type**: `string`
- **Default Value**: `#QWEASDasdqwe`

#### ACA Environment Variables

##### ACA Environment

- **Variable Name**: `aca-env`
- **Type**: `string`
- **Default Value**: `dify-aca-env`

##### ACA Log Analytics Workspace

- **Variable Name**: `aca-loga`
- **Type**: `string`
- **Default Value**: `dify-loga`

##### IF BRING YOUR OWN CERTIFICATE

- **Variable Name**: `isProvidedCert`
- **Type**: `bool`
- **Default Value**: `false`


##### ACA Certificate Path (if isProvidedCert is true)

- **Variable Name**: `aca-cert-path`
- **Type**: `string`
- **Default Value**: `./certs/difycert.pfx`

##### ACA Certificate Password (if isProvidedCert is true)

- **Variable Name**: `aca-cert-password`
- **Type**: `string`
- **Default Value**: `password`

##### ACA Dify Customer Domain (if isProvidedCert is false)

- **Variable Name**: `aca-dify-customer-domain`
- **Type**: `string`
- **Default Value**: `dify.nikadwang.com`

#### Container Images

##### Dify API Image

- **Variable Name**: `dify-api-image`
- **Type**: `string`
- **Default Value**: `langgenius/dify-api:0.6.11`

##### Dify Sandbox Image

- **Variable Name**: `dify-sandbox-image`
- **Type**: `string`
- **Default Value**: `langgenius/dify-sandbox:0.2.1`

##### Dify Web Image

- **Variable Name**: `dify-web-image`
- **Type**: `string`
- **Default Value**: `langgenius/dify-web:0.6.11`