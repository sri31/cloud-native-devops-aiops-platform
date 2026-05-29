# ──────────────────────────────────────────
# Application Variables
# ──────────────────────────────────────────
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "cloud-native-devops-aiops-platform"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "devops-aiops"
}

variable "image_name" {
  description = "Docker image name"
  type        = string
  default     = "srinidhi1989/cloud-native-devops-aiops-platform"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "v1.0.1"
}

variable "replicas" {
  description = "Number of app replicas"
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Port the app runs on"
  type        = number
  default     = 8000
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}