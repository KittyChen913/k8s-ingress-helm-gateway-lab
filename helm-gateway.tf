# 部署 Envoy Gateway（Gateway API Controller）
resource "helm_release" "envoy_gateway" {
  name             = "envoy-gateway"
  chart            = "gateway-helm"
  repository       = "oci://docker.io/envoyproxy"
  version          = var.envoy_gateway_version
  namespace        = var.gateway_namespace
  create_namespace = true

  values = [
    yamlencode({
      deployment = {
        envoyGateway = {
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
        }
      }
    })
  ]

  # wait = false：Helm Chart 立即返回，不等待 Pod Ready，避免 Terraform 在等待 Pod 啟動時超時
  wait = false
}

# GatewayClass
resource "kubernetes_manifest" "envoy_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"
    metadata = {
      name = "eg"
    }
    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
    }
  }

  depends_on = [
    helm_release.envoy_gateway
  ]
}
