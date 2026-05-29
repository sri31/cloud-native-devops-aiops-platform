# ──────────────────────────────────────────
# Terraform Version Requirements
# ──────────────────────────────────────────
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# ──────────────────────────────────────────
# Kubernetes Provider Configuration
# Points to Minikube cluster
# ──────────────────────────────────────────
provider "kubernetes" {
  config_path    = "/home/srinidhi_k_s/.kube/config"
  config_context = "minikube"
}