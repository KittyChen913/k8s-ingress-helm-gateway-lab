variable "k8s_context" {
  description = "Kubernetes context name"
  type        = string
  default     = "minikube"
}

variable "namespace" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "gateway-lab"
}

variable "gateway_namespace" {
  description = "Gateway controller namespace name"
  type        = string
  default     = "gateway-system"
}

variable "envoy_gateway_version" {
  description = "Envoy Gateway Helm chart version"
  type        = string
  default     = "1.2.0"
}

variable "grafana_admin_password" {
  description = "Grafana admin user password"
  type        = string
}
