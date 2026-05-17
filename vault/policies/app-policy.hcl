# Application Policy
# Used by FastAPI app running in Kubernetes
# Can only read app secrets

path "secret/data/app" {
  capabilities = ["read"]
}