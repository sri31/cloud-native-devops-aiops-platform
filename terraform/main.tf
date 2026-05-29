# ──────────────────────────────────────────
# 1. Namespace
# ──────────────────────────────────────────
resource "kubernetes_namespace" "devops_aiops" {
  metadata {
    name = var.namespace

    labels = {
      app         = var.app_name
      environment = var.environment
      managed_by  = "terraform"
    }
  }
}

# ──────────────────────────────────────────
# 2. ConfigMap — App Configuration
# ──────────────────────────────────────────
resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${var.app_name}-config"
    namespace = kubernetes_namespace.devops_aiops.metadata[0].name

    labels = {
      app         = var.app_name
      environment = var.environment
      managed_by  = "terraform"
    }
  }

  data = {
    APP_NAME    = var.app_name
    ENVIRONMENT = var.environment
    APP_PORT    = tostring(var.app_port)
    IMAGE_TAG   = var.image_tag
  }
}

# ──────────────────────────────────────────
# 3. Deployment — Run the App
# ──────────────────────────────────────────
resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.devops_aiops.metadata[0].name

    labels = {
      app         = var.app_name
      environment = var.environment
      managed_by  = "terraform"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_name
          environment = var.environment
        }
      }

      spec {
        container {
          name  = var.app_name
          image = "${var.image_name}:${var.image_tag}"

          port {
            container_port = var.app_port
          }

          # Resource limits
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # Liveness probe — is app alive?
          liveness_probe {
            http_get {
              path = "/health"
              port = var.app_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          # Readiness probe — is app ready to serve traffic?
          readiness_probe {
            http_get {
              path = "/health"
              port = var.app_port
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          # Environment variables from ConfigMap
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }
        }
      }
    }
  }
}

# ──────────────────────────────────────────
# 4. Service — Expose the App
# ──────────────────────────────────────────
resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = kubernetes_namespace.devops_aiops.metadata[0].name

    labels = {
      app         = var.app_name
      environment = var.environment
      managed_by  = "terraform"
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = var.app_port
    }

    type = "NodePort"
  }
}

# ──────────────────────────────────────────
# 5. ResourceQuota — Limit Resource Usage
# ──────────────────────────────────────────
resource "kubernetes_resource_quota" "devops_aiops" {
  metadata {
    name      = "${var.namespace}-quota"
    namespace = kubernetes_namespace.devops_aiops.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "1"
      "requests.memory" = "1Gi"
      "limits.cpu"      = "2"
      "limits.memory"   = "2Gi"
      "pods"            = "10"
    }
  }
}