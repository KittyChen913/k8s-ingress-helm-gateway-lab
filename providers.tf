terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }

  # 本地狀態存儲
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Kubernetes Provider 配置
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.k8s_context
}

# Helm Provider 配置
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.k8s_context
  }
}
