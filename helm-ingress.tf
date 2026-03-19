# 部署 Nginx Ingress Controller
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = var.nginx_ingress_version
  namespace        = var.namespace
  create_namespace = false # 使用已存在的 namespace

  # Nginx Ingress 配置值
  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
        }
        resources = {
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        replicaCount = 1
      }
      # 不安裝 Prometheus 監控套件，節省資源
      prometheus = {
        create = false
      }
    })
  ]
}
