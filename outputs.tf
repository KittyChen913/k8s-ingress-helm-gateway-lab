output "namespace" {
  description = "Deployed Kubernetes namespace name"
  value       = kubernetes_namespace.lab.metadata[0].name
}

output "nginx_ingress_status" {
  description = "Nginx Ingress Controller deployment status"
  value       = "Nginx Ingress deployed in ${helm_release.nginx_ingress.namespace} namespace"
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

3. Next: Deploy Nginx Ingress Controller
   terraform apply

=====================================
EOT
}
