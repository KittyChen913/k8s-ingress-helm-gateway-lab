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
