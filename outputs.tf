output "namespace" {
  description = "Deployed Kubernetes namespace name"
  value       = kubernetes_namespace.lab.metadata[0].name
}

output "gateway_controller_status" {
  description = "Gateway API controller deployment status"
  value       = "Envoy Gateway deployed in ${helm_release.envoy_gateway.namespace} namespace"
}

output "grafana_status" {
  description = "Grafana deployment status"
  value       = "Grafana deployed in ${helm_release.grafana.namespace} namespace"
}

output "grafana_admin_credentials" {
  description = "Grafana admin login credentials"
  value = {
    url      = "http://grafana.local"
    username = "admin"
    password = var.grafana_admin_password
  }
}

output "k8s_context" {
  description = "Current Kubernetes context in use"
  value       = var.k8s_context
}

output "deployment_instructions" {
  description = "Deployment instructions and next steps"
  value       = <<-EOT
=====================================
Terraform Basic Environment Ready!
=====================================

1. Verify Minikube is running:
   minikube status

2. Namespace created:
   kubectl get namespace ${kubernetes_namespace.lab.metadata[0].name}

3. Next: Deploy Gateway API stack
   terraform apply

=====================================
EOT
}
