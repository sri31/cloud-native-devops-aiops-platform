# ──────────────────────────────────────────
# Outputs — Display useful information
# after terraform apply
# ──────────────────────────────────────────

output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.devops_aiops.metadata[0].name
}

output "app_name" {
  description = "Application name"
  value       = var.app_name
}

output "image" {
  description = "Docker image deployed"
  value       = "${var.image_name}:${var.image_tag}"
}

output "replicas" {
  description = "Number of replicas running"
  value       = var.replicas
}

output "service_name" {
  description = "Kubernetes service name"
  value       = kubernetes_service.app.metadata[0].name
}

output "deployment_name" {
  description = "Kubernetes deployment name"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "access_command" {
  description = "Command to access the app"
  value       = "minikube service ${var.app_name}-service -n ${var.namespace}"
}