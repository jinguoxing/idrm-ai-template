# IDRM AI Template

> Go-Zero 微服务项目模板，支持多服务类型与完整 DevOps 工作流

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Go Version](https://img.shields.io/badge/Go-1.24+-00ADD8?logo=go)](https://go.dev)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](deploy/docker)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Helm-326CE5?logo=kubernetes)](deploy/helm)

---

## ✨ 功能特点

- ✅ **多服务类型**：API / RPC / Job / Consumer
- ✅ **Go-Zero 框架**：内置 zRPC、任务调度、消息队列抽象层
- ✅ **Spec Kit 集成**：`.specify/` 模板和提示词
- ✅ **完整规范文档**：`sdd_doc/spec/` 开发规范
- ✅ **Telemetry 支持**：Logging、Tracing、Audit
- ✅ **公共包**：middleware、response、validator
- ✅ **容器化支持**：Docker、docker-compose
- ✅ **K8S 部署**：Helm Chart 多环境配置
- ✅ **CI/CD**：GitHub Actions 完整流程

---

## 🚀 快速开始

> **💡 提示**：根据你的情况选择合适的方式
> - **新项目**：直接使用模板创建 → 见下方步骤
> - **现有项目**：选择性引入模板功能 → 见 [入门指南](doc/getting-started.md#场景-b现有项目引入模板)
> - **仅用规范**：只使用开发规范和 AI 辅助 → 见 [入门指南](doc/getting-started.md#场景-c仅使用规范文档)
>
> 详细说明：[模板使用指南 →](doc/getting-started.md)

### 1. 使用模板

```bash
# 克隆模板
git clone https://github.com/jinguoxing/idrm-ai-template.git my-project
cd my-project

# 初始化项目（选择所需服务）
./scripts/init.sh github.com/myorg/my-project

# 或非交互式指定服务
./scripts/init.sh github.com/myorg/my-project --services api,rpc --yes
```

### 2. 本地开发

```bash
# 使用 docker-compose 启动完整环境
cd deploy/docker
docker-compose up -d

# 访问服务
curl http://localhost:8888/health  # API
```

### 3. 生成代码

```bash
# 生成 API 代码
make api

# 生成 RPC 代码（protobuf）
goctl rpc protoc rpc/proto/service.proto --go_out=rpc/pb --go-grpc_out=rpc/pb --zrpc_out=rpc/
```

### 4. 运行服务

```bash
# API 服务
go run api/api.go -f api/etc/api.yaml

# RPC 服务
go run rpc/rpc.go -f rpc/etc/rpc.yaml

# Job 服务
go run job/job.go -f job/etc/job.yaml

# Consumer 服务
go run consumer/consumer.go -f consumer/etc/consumer.yaml
```

---

## 📦 服务类型

| 服务 | 说明 | 技术栈 |
|------|------|--------|
| **API** | HTTP API 服务 | Go-Zero REST |
| **RPC** | gRPC 服务 | Go-Zero zRPC |
| **Job** | 定时任务服务 | K8S CronJob / asynq (计划) |
| **Consumer** | 消息消费者 | Kafka / TongLINK / Q-CN |

### 消息队列支持

Consumer 服务通过 **抽象接口** 支持多种消息中间件：

| 类型 | 状态 | 说明 |
|------|------|------|
| **Kafka** | ✅ | 基于 go-zero kq |
| **TongLINK/Q-CN** | 🚧 | 国产消息中间件 |
| **Redis Stream** | 📋 | 计划中 |

---

## 📂 目录结构

```
.
├── .specify/                  # Spec Kit 配置
│   ├── memory/               # 项目宪法
│   └── templates/            # 需求/设计/任务模板
├── .github/
│   ├── prompts/              # AI 提示词
│   └── workflows/            # CI/CD 工作流
│       ├── ci.yaml          # 持续集成
│       ├── build.yaml       # 镜像构建
│       └── deploy.yaml      # K8S 部署
├── sdd_doc/spec/             # 规范文档
│
├── api/                      # HTTP API 服务
│   ├── api.go               # 入口文件
│   ├── doc/                 # API 定义
│   ├── etc/                 # 配置
│   └── internal/            # Handler/Logic 分层
│
├── rpc/                      # gRPC 服务
│   ├── rpc.go               # 入口文件
│   ├── proto/               # Protobuf 定义
│   ├── etc/                 # 配置
│   └── internal/            # Server/Logic 分层
│
├── job/                      # 定时任务服务
│   ├── job.go               # 入口文件
│   └── internal/handler/    # 任务处理器
│
├── consumer/                 # 消息消费者服务
│   ├── consumer.go          # 入口文件
│   └── internal/
│       ├── mq/              # MQ 抽象层
│       │   ├── interface.go # 统一接口
│       │   ├── kafka.go     # Kafka 实现
│       │   └── tonglink.go  # TongLINK 实现
│       └── handler/         # 消息处理器
│
├── pkg/                      # 公共包
│   ├── middleware/          # 中间件 (Auth/Trace)
│   ├── response/            # 响应处理
│   ├── telemetry/           # 遥测 (Log/Trace/Audit)
│   └── validator/           # 验证器
│
├── model/                    # Model 层（Dual ORM）
├── migrations/               # 数据库迁移
│
├── deploy/                   # 部署配置
│   ├── docker/              # Docker 支持
│   │   ├── Dockerfile.*     # 各服务镜像
│   │   ├── docker-compose.yaml
│   │   └── build.sh
│   └── helm/idrm/           # Helm Chart
│       ├── Chart.yaml
│       ├── values*.yaml     # 多环境配置
│       └── templates/       # K8S 清单
│
├── doc/                      # 文档
│   ├── claude-code-guide.md
│   ├── cursor-speckit-guide.md
│   └── deployment-guide.md
│
├── .cursorrules              # Cursor 配置
└── CLAUDE.md                 # Claude 配置
```

---

## 🔄 开发流程

采用 **5 阶段 Spec-Driven 开发**：

```
Phase 0: Context (上下文准备)
    ↓
Phase 1: Specify (需求规范)
    ↓
Phase 2: Design (技术方案)
    ↓
Phase 3: Tasks (任务拆分)
    ↓
Phase 4: Implement (实施验证)
```

**AI 辅助工具支持**：
- [Claude Code 开发指导](doc/claude-code-guide.md)
- [Cursor + Spec-Kit 指导](doc/cursor-speckit-guide.md)
- [用户认证示例](doc/examples/user-auth-workflow.md)

---

## 💡 设计理念

### Spec-Kit 集成方式

本模板提供 **两种使用方式**，灵活适配不同团队需求：

| 方式 | 适用场景 | 优点 | 缺点 |
|------|----------|------|------|
| **方式 1: Spec-Kit CLI** | Cursor 用户，追求自动化 | 斜杠命令快速生成规范文档 | 需要安装 `specify-cli` |
| **方式 2: 直接使用模板** | Claude Code 用户，灵活控制 | 无需安装，AI 直接理解 `.specify/` | 需手动引用模板路径 |

### 核心设计原则

```
              Spec-Kit CLI 命令
                     ↓
                 读取并处理
                     ↓
        .specify/ 模板文件  ←  AI 也可直接读取
                     ↓
                指导开发流程
```

**关键特性**：
1. ✅ **模板独立存在**：`.specify/` 中的 Markdown 文件是自包含的知识库
2. ✅ **AI 原生支持**：Claude/Cursor 可以直接理解和应用这些模板
3. ✅ **工具增强可选**：Spec-Kit CLI 是锦上添花，非必需
4. ✅ **团队自主选择**：根据工具链自由选择使用方式

### 实践建议

- **Cursor 用户**：推荐安装 Spec-Kit CLI，使用 `/speckit.*` 命令
- **Claude Code 用户**：直接引用模板文件，如 "请按照 `.specify/templates/requirements-template.md` 创建规范"
- **混合团队**：两种方式产出的文档格式一致，可无缝协作

详见：
- [Claude Code 使用指南](doc/claude-code-guide.md#spec-kit-集成)
- [Cursor + Spec-Kit 指导](doc/cursor-speckit-guide.md#使用方式对比)

---

## 🐳 Docker 部署

### 本地开发环境

```bash
cd deploy/docker
docker-compose up -d
```

**默认服务**：
- API: http://localhost:8888
- RPC: localhost:9999
- MySQL: localhost:3306
- Redis: localhost:6379
- Kafka: localhost:9092

### 构建镜像

```bash
# 批量构建所有服务镜像
cd deploy/docker
./build.sh

# 或单独构建
docker build -f deploy/docker/Dockerfile.api -t myorg/idrm-api:latest .
```

---

## ☸️ Kubernetes 部署

### 使用 Helm Chart

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

### 更新部署

```bash
helm upgrade idrm ./deploy/helm/idrm \
  -f ./deploy/helm/idrm/values-prod.yaml \
  --set global.image.tag=v1.0.1 \
  --namespace prod
```

详见 [部署指南](doc/deployment-guide.md)

---

## 🔧 命令参考

```bash
# 项目初始化
./scripts/init.sh github.com/myorg/my-project                 # 交互式
./scripts/init.sh github.com/myorg/my-project --services api,rpc --yes  # 非交互式

# 代码生成
make api           # 生成 API 代码
make proto         # 生成 RPC protobuf 代码

# 开发
make lint          # 代码检查
make test          # 运行测试
make build         # 编译所有服务

# Docker
docker-compose up -d            # 启动本地环境
./deploy/docker/build.sh        # 构建镜像

# Helm
helm install idrm ./deploy/helm/idrm -f values-dev.yaml
helm upgrade idrm ./deploy/helm/idrm --set global.image.tag=v1.0.1
```

---

## 📚 文档索引

### 开发指南

| 文档 | 说明 |
|------|------|
| [模板使用指南](doc/getting-started.md) | 新项目/现有项目的使用方式 |
| [分层架构](sdd_doc/spec/architecture/layered-architecture.md) | Handler/Logic/Model 架构规范 |
| [API 服务指南](sdd_doc/spec/architecture/api-service-guide.md) | API 服务开发指南 |
| [命名规范](sdd_doc/spec/coding-standards/naming-conventions.md) | Go 代码命名规范 |

### AI 辅助开发

| 文档 | 说明 |
|------|------|
| [Claude Code 指导](doc/claude-code-guide.md) | AI 辅助开发完整指南 |
| [Cursor + Spec-Kit 指导](doc/cursor-speckit-guide.md) | Cursor 斜杠命令指南 |
| [用户认证示例](doc/examples/user-auth-workflow.md) | 5 阶段完整开发示例 |

### 部署运维

| 文档 | 说明 |
|------|------|
| [部署指南](doc/deployment-guide.md) | Docker、K8S 完整部署指南 |

---

## 🔄 CI/CD

### GitHub Actions Workflows

| Workflow | 触发条件 | 说明 |
|----------|----------|------|
| **CI** | Push/PR | Lint + Test + Build |
| **Build** | Tag push | 构建并推送镜像到 GHCR |
| **Deploy** | 手动触发 | 部署到 K8S 集群 |

### 发布流程

```bash
# 1. 打 tag 触发镜像构建
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 2. 在 GitHub Actions 手动触发部署
# 选择环境 (dev/staging/prod) 和镜像 tag
```

---

## 🛠️ 技术栈

| 组件 | 技术 |
|------|------|
| **框架** | Go-Zero 1.9+ |
| **API** | REST / gRPC |
| **数据库** | MySQL 8.0 (支持 Dual ORM) |
| **缓存** | Redis 7.0 |
| **消息队列** | Kafka / TongLINK / Q-CN |
| **容器化** | Docker / docker-compose |
| **编排** | Kubernetes / Helm 3 |
| **CI/CD** | GitHub Actions |
| **监控** | OpenTelemetry (Jaeger) |

---

## 📄 License

MIT © IDRM Team

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

更多信息请查看[贡献指南](CONTRIBUTING.md)（待补充）
