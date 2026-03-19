# 部署官方 Grafana Helm Chart
resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = var.namespace

  # 官方 Grafana Helm 倉庫
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "7.0.0"
  create_namespace = false

  values = [yamlencode({
    replicas = 1

    # 管理員帳號
    adminUser     = "admin"
    adminPassword = var.grafana_admin_password

    service = {
      type = "ClusterIP"
      port = 80
    }

    resources = {
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
      limits = {
        cpu    = "200m"
        memory = "256Mi"
      }
    }

    ingress = {
      enabled = false
    }

    # 持久化配置
    persistence = {
      enabled = false
    }

    # 資料來源配置
    datasources = {
      "datasources.yaml" = {
        apiVersion  = 1
        datasources = []
      }
    }
  })]

  # wait = false：Helm Chart 立即返回，不等待 Pod Ready，避免 Terraform 在等待 Pod 啟動時超時
  wait = false

  depends_on = [
    kubernetes_namespace.lab
  ]
}
