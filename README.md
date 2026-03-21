# k8s-helm-gateway-api-lab

透過 Terraform 在 Minikube 上部署 Envoy Gateway 與 Grafana，並使用 Kubernetes Gateway API 進行流量路由的實驗室環境。

## 系統架構


```
外部請求
    │
    ▼
grafana.local (Port 80)
    │
    ▼
[ Envoy Gateway ]  ← Gateway API Controller (gateway-system)
    │
    ▼  HTTPRoute: grafana.local → /
[ grafana Service (ClusterIP:80) ]  (gateway-lab)
    │
    ▼
[ Grafana Pod ]
```

此配置會部署以下資源：

- **Kubernetes Namespace**：建立專用的 `gateway-lab` Namespace，並標記為由 Terraform 管理
- **Envoy Gateway**：透過 Helm Chart 部署 Envoy Gateway 作為 Gateway API Controller，安裝於 `gateway-system` Namespace
- **GatewayClass**：建立名為 `eg` 的 GatewayClass，對應 Envoy Gateway Controller
- **Grafana**：透過官方 Helm Chart 部署 Grafana，Service 類型為 ClusterIP，安裝於 `gateway-lab` Namespace
- **Gateway**：建立 `grafana-gateway`，監聽 Port 80，Host 為 `grafana.local`
- **HTTPRoute**：建立 `grafana-route`，將 `grafana.local` 的所有路徑（`/`）路由到 Grafana Service

## 前置需求

1. **Minikube**：安裝並啟動 Minikube 作為本地 Kubernetes Cluster
2. **kubectl**：安裝 kubectl 用於管理 Kubernetes 資源
3. **Terraform**：安裝 Terraform `>= 1.0`
4. **Helm**：Terraform Helm Provider 會自動使用 `~/.kube/config` 中的連線設定

## 🚀 快速開始

### 1. 啟動 Minikube

```bash
minikube start
```

### 2. 複製配置文件

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 3. 編輯配置文件

編輯 `terraform.tfvars`，**唯一必填**的變數為 `grafana_admin_password`（其餘皆有預設值）：

```hcl
# ✅ 必填：Grafana 管理員密碼（無預設值）
grafana_admin_password = "your-password-here"
```

### 4. 初始化 & 部署

```bash
terraform init
terraform plan
terraform apply
```

### 5. 確認部署狀態

確認 Namespace 建立
```bash
kubectl get namespace gateway-lab gateway-system
```

確認 Envoy Gateway Pod 運行
```bash
kubectl get pods -n gateway-system
```

確認 Grafana Pod 運行
```bash
kubectl get pods -n gateway-lab
```

確認 Gateway API 資源
```bash
kubectl get gateway,httproute -n gateway-lab
```

### 6. 啟動 Minikube Tunnel（取得 External IP 的前提）

在 Minikube 環境中，LoadBalancer 類型的 Service 預設 External IP 會顯示 `<pending>`，必須先執行以下指令並**保持此終端機開著**：

```bash
minikube tunnel
```

### 7. 取得 Envoy Proxy 的 External IP

`terraform apply` 建立 `Gateway` 資源後，Envoy Gateway 會自動建立一個對應的 Proxy Service。

在另一個終端機執行以下指令，找到 `TYPE` 為 `LoadBalancer` 的 Service，其 `EXTERNAL-IP` 即為入口 IP：

```bash
kubectl get service -n gateway-system
```

### 8. 設定本機 hosts

將以下內容加入本機 hosts 檔案：

- Linux/macOS：`/etc/hosts`
- Windows：`C:\Windows\System32\drivers\etc\hosts`

```
<EXTERNAL-IP>  grafana.local
```

### 8. 訪問 Grafana

開啟瀏覽器前往 `http://grafana.local`，使用以下帳號登入：

- **帳號**：`admin`
- **密碼**：`terraform.tfvars` 中設定的 `grafana_admin_password`

### 9. 清理資源

```bash
terraform destroy
```

## 📁 檔案結構

```
📁 k8s-helm-gateway-api-lab/
├── 📄 providers.tf                   # Terraform、Kubernetes 與 Helm Provider 配置
├── 📄 variables.tf                   # 變數定義
├── 📄 kubernetes.tf                  # Kubernetes Namespace 資源配置
├── 📄 helm-gateway.tf                # Envoy Gateway Helm Release 與 GatewayClass 配置
├── 📄 helm-grafana.tf                # Grafana Helm Release 配置
├── 📄 gateway-rules.tf               # Gateway 與 HTTPRoute 路由規則配置
├── 📄 outputs.tf                     # 輸出值定義
├── 📄 terraform.tfvars               # 變數值（根據需要自訂，請勿提交至 Git）
├── 📄 terraform.tfvars.example       # 變數值範例
├── 📄 terraform.tfstate              # Terraform 狀態檔（自動生成）
├── 📄 terraform.tfstate.backup       # Terraform 狀態備份（自動生成）
└── 📄 README.md                      # 專案說明文件
```

## ⚠️ 注意事項

1. 🔐 **密碼請勿洩露** — `grafana_admin_password` 建議透過 `terraform.tfvars` 或環境變數 `TF_VAR_grafana_admin_password` 設定，不要將 `terraform.tfvars` 提交至 Git
2. ⏳ **`wait = false` 說明** — `helm-gateway.tf` 與 `helm-grafana.tf` 中的 `wait = false` 讓 Helm Release 立即返回而不等待 Pod Ready，若後續 `kubectl` 指令顯示 Pod 尚未就緒，請稍等片刻
3. 🌐 **Minikube Tunnel** — 在 Minikube 環境中，Service Type 為 `LoadBalancer` 的資源需執行 `minikube tunnel` 才能取得 External IP
4. ⚙️ **自訂部署設定** — 可編輯 `terraform.tfvars` 調整部署參數（如 `k8s_context`、`namespace`、`envoy_gateway_version`）；若要調整 CPU/記憶體限制，請在 [helm-gateway.tf](helm-gateway.tf) 或 [helm-grafana.tf](helm-grafana.tf) 中修改 `resources` 區塊
5. 🗂️ **Gateway API CRD** — Envoy Gateway Helm Chart 會自動安裝 Gateway API CRD，若叢集已有舊版 CRD，請先確認版本相容性

