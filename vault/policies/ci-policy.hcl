# CI Pipeline Policy
# Used by GitHub Actions
# Can only read CI related secrets

path "secret/data/docker" {
  capabilities = ["read"]
}

path "secret/data/sonarqube" {
  capabilities = ["read"]
}

path "secret/data/github" {
  capabilities = ["read"]
}