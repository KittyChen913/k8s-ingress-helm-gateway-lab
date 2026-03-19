# 創建專用的 Namespace
resource "kubernetes_namespace" "lab" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "environment"                  = "lab"
      "ingress-nginx"                = "enabled"
    }
  }
}
