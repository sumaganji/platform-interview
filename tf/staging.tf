
resource "vault_audit" "audit_staging" {
  provider = vault.vault_staging
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_staging" {
  provider = vault.vault_staging
  type     = "userpass"
}

resource "vault_generic_secret" "account_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "396e73e7-34d5-4b0a-ae1b-b128aa7f9978"
}
EOT
}

resource "vault_policy" "account_staging" {
  provider = vault.vault_staging
  name     = "account-staging"

  policy = <<EOT

path "secret/data/staging/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/account-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-staging"],
  "password": "123-account-staging"
}
EOT
}

resource "vault_generic_secret" "gateway_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "33fc0cc8-b0e3-4c06-8cf6-c7dce2705320"
}
EOT
}

resource "vault_policy" "gateway_staging" {
  provider = vault.vault_staging
  name     = "gateway-staging"

  policy = <<EOT

path "secret/data/staging/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/gateway-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-staging"],
  "password": "123-gateway-staging"
}
EOT
}

resource "vault_generic_secret" "payment_staging" {
  provider = vault.vault_staging
  path     = "secret/staging/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e30"
}
EOT
}

resource "vault_policy" "payment_staging" {
  provider = vault.vault_staging
  name     = "payment-staging"

  policy = <<EOT

path "secret/data/staging/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_staging" {
  provider             = vault.vault_staging
  depends_on           = [vault_auth_backend.userpass_staging]
  path                 = "auth/userpass/users/payment-staging"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-staging"],
  "password": "123-payment-staging"
}
EOT
}

resource "docker_container" "account_staging" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=account-staging",
    "VAULT_PASSWORD=123-account-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_staging" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=gateway-staging",
    "VAULT_PASSWORD=123-gateway-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_staging" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=payment-staging",
    "VAULT_PASSWORD=123-payment-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "frontend_staging" {
  image = "docker.io/nginx:1.22.0-alpine"
  name  = "frontend_staging"

  ports {
    internal = 80
    external = 4083
  }

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}