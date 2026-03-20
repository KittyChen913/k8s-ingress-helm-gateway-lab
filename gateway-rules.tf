# Gateway API 規則配置
# 建立 Gateway 與 HTTPRoute，將 grafana.local 路由到 Grafana Service
resource "kubernetes_manifest" "grafana_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "grafana-gateway"
      namespace = var.namespace
    }
    spec = {
      gatewayClassName = "eg"
      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
          hostname = "grafana.local"
          allowedRoutes = {
            namespaces = {
              from = "Same"
            }
          }
        }
      ]
    }
  }

  depends_on = [
    kubernetes_namespace.lab,
    helm_release.envoy_gateway,
    kubernetes_manifest.envoy_gateway_class
  ]
}

resource "kubernetes_manifest" "grafana_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "grafana-route"
      namespace = var.namespace
    }
    spec = {
      hostnames = ["grafana.local"]
      parentRefs = [
        {
          name = "grafana-gateway"
        }
      ]
      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]
          backendRefs = [
            {
              name = "grafana"
              port = 80
            }
          ]
        }
      ]
    }
  }

  depends_on = [
    helm_release.grafana,
    kubernetes_manifest.grafana_gateway
  ]
}
