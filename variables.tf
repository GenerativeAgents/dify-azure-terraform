variable "subscription-id" {
  type = string
}

variable "resource_group_prefix" {
  type = string
}

variable "company_name" {
  type = string
  nullable = true
}

variable "env" {
  type = string
}

#virtual network variables
variable "region" {
  type = string
  default = "japaneast"
}

variable "ip-prefix" {
  type = string
  default = "10.99"
}

variable "storage-account" {
  type = string
  default = "acadifytest"
}

variable "storage-account-container" {
  type = string
  default = "dfy"
}

variable "redis" {
  type = string
  default = "acadifyredis"
}

variable "psql-flexible" {
  type = string
  default = "acadifypsql"
}

variable "pgsql-user" {
  type = string
  default = "user"
}

variable "aca-env" {
  type = string
  default = "dify-aca-env"
}

variable "aca-loga" {
  type = string
  default = "dify-loga"
}

variable "isProvidedCert" {
  type = bool
  default = false
}

variable "aca-cert-path" {
  type = string
  default = "./certs/difycert.pfx"
}

variable "aca-dify-customer-domain" {
  type = string
  default = "dify-app-prod.generative-agents.co.jp"
}

variable "aca-app-min-count" {
  type = number
  default = 1
}

variable "is_aca_enabled" {
  type = bool
  default = true
}

variable "dify-api-image" {
  type = string
  default = "langgenius/dify-api:0.7.1"
}

variable "dify-sandbox-image" {
  type = string
  default = "langgenius/dify-sandbox:0.2.6"
}

variable "dify-web-image" {
  type = string
  default = "langgenius/dify-web:0.7.1"
}

variable "nginx-cpu-size" {
  type = string
  default = "1.0"
}

variable "nginx-memory-size" {
  type = string
  default = "2Gi"
}

variable "ssrfproxy-cpu-size" {
  type = string
  default = "1.0"
}

variable "ssrfproxy-memory-size" {
  type = string
  default = "2Gi"
}

variable "worker-cpu-size" {
  type = string
  default = "2"
}

variable "worker-memory-size" {
  type = string
  default = "4Gi"
}

variable "api-cpu-size" {
  type = string
  default = "4"
}

variable "api-memory-size" {
  type = string
  default = "8Gi"
}

variable "postgres-sku-name" {
  type = string
  default = "B_Standard_B2ms"
}

variable "web_ip_security_restrictions" {
  type = list(object({
    description = string
    name = string
    ip_address_range = string
  }))
  description = "Dify Web IP Security Restrictions"
}