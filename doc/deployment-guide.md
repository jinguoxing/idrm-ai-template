# 部署指南

本指南介绍如何使用 Docker 和 Kubernetes 部署 IDRM 服务。

---

## Docker 部署

### 使用 docker-compose (本地开发)

```bash
cd deploy/docker
docker-compose up -d
```

默认启动的服务：
- API: http://localhost:8888
- RPC: localhost:9999
- MySQL: localhost:3306
- Redis: localhost:6379
- Kafka: localhost:9092

### 构建镜像

```bash
# 使用构建脚本
cd deploy/docker
./build.sh

# 或手动构建
docker build -f deploy/docker/Dockerfile.api -t myorg/idrm-api:latest .
```

### 推送镜像

```bash
export REGISTRY=ghcr.io/myorg
export TAG=v1.0.0

./deploy/docker/build.sh
docker push $REGISTRY/idrm-api:$TAG
```

---

## Kubernetes 部署 (Helm)

### 前置要求

- Kubernetes 集群 (1.20+)
- Helm 3.x
- kubectl 配置

### 安装

```bash
# 开发环境
helm install idrm ./deploy/helm/idrm \
  -f ./deploy/helm/idrm/values-dev.yaml \
  --namespace dev \
  --create-namespace

# 生产环境
helm install idrm ./deploy/helm/idrm \
  -f ./deploy/helm/idrm/values-prod.yaml \
  --set global.image.tag=v1.0.0 \
  --set secrets.mysql.password=<password> \
  --namespace prod \
  --create-namespace
```

### 更新

```bash
helm upgrade idrm ./deploy/helm/idrm \
  -f ./deploy/helm/idrm/values-prod.yaml \
  --set global.image.tag=v1.0.1 \
  --namespace prod
```

### 卸载

```bash
helm uninstall idrm --namespace prod
```

### 查看状态

```bash
# 查看部署
kubectl -n prod get deployments
kubectl -n prod get pods
kubectl -n prod get svc

# 查看日志
kubectl -n prod logs -f deployment/idrm-api
```

---

## GitHub Actions CI/CD

### 触发构建

推送 tag 自动构建镜像：

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 手动部署

1. 进入 GitHub Actions
2. 选择 "Deploy" workflow
3. 点击 "Run workflow"
4. 选择环境 (dev/staging/prod) 和镜像 tag

### 所需 Secrets

在 GitHub 仓库设置中添加：

| Secret | 说明 |
|--------|------|
| `KUBECONFIG` | Kubernetes 配置文件 (base64) |
| `MYSQL_PASSWORD` | MySQL 密码 |

---

## 配置管理

### 环境变量

通过 Helm values 文件管理：

```yaml
# values-prod.yaml
api:
  env:
    - name: LOG_LEVEL
      value: "info"
    - name: CUSTOM_VAR
      value: "value"
```

### Secrets

敏感信息使用 Kubernetes Secret：

```bash
kubectl -n prod create secret generic custom-secret \
  --from-literal=api-key=xxx
```

在 Helm values 中引用：

```yaml
api:
  env:
    - name: API_KEY
      valueFrom:
        secretKeyRef:
          name: custom-secret
          key: api-key
```

---

## 故障排查

### 常见问题

**1. Pod 启动失败**

```bash
kubectl -n prod describe pod <pod-name>
kubectl -n prod logs <pod-name>
```

**2. 镜像拉取失败**

检查镜像仓库权限：

```bash
kubectl -n prod create secret docker-registry ghcr \
  --docker-server=ghcr.io \
  --docker-username=<username> \
  --docker-password=<token>
```

在 Deployment 中使用：

```yaml
spec:
  imagePullSecrets:
    - name: ghcr
```

**3. 服务无法访问**

检查 Service 和 Ingress：

```bash
kubectl -n prod get svc
kubectl -n prod get ingress
kubectl -n prod describe ingress idrm-api
```

---

## 监控和日志

### 日志查看

```bash
# 实时日志
kubectl -n prod logs -f deployment/idrm-api --tail=100

# 多容器 pods
kubectl -n prod logs -f deployment/idrm-api -c api
```

### 健康检查

所有服务提供健康检查端点：

- `/health` - 存活检查
- `/ready` - 就绪检查

---

## 最佳实践

1. **使用命名空间隔离环境**
2. **通过 values 文件管理配置**
3. **敏感信息使用 Secret**
4. **设置资源限制**
5. **启用 HPA 自动扩缩容**
6. **配置日志和监控**
7. **使用 Ingress 管理外部访问**
