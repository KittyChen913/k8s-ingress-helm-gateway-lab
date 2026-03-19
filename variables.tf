variable "k8s_context" {
  description = "Kubernetes context name"
  type        = string
  default     = "minikube"
}

variable "namespace" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "ingress-lab"
}

variable "nginx_ingress_version" {
  description = "Nginx Ingress Chart version"
  type        = string
  default     = "4.8.3"
}

variable "grafana_admin_password" {
  description = "Grafana admin user password"
  type        = string
}
