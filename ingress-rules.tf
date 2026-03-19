# Ingress 規則配置
# 將 Grafana Service 通過主機名路由暴露
resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = var.namespace
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "grafana.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.grafana,
    helm_release.nginx_ingress
  ]
}
