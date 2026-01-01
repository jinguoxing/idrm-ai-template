# IDRM AI Template

> Go-Zero 微服务项目模板，包含 AI 辅助开发规范

---

## 功能特点

- ✅ **多服务类型**：API / RPC / Job / Consumer
- ✅ **Go-Zero 框架**：内置 zRPC、任务调度、消息队列抽象层
- ✅ **Spec Kit 集成**：`.specify/` 模板和提示词
- ✅ **完整规范文档**：`sdd_doc/spec/` 开发规范
- ✅ **Telemetry 支持**：Logging、Tracing、Audit
- ✅ **公共包**：middleware、response、validator
- 🚧 **部署支持**：Docker、Helm Chart (开发中)

---

## 快速开始

### 1. 使用模板

```bash
# 克隆模板
git clone https://github.com/jinguoxing/idrm-ai-template.git my-project
cd my-project

# 初始化项目（替换模块路径）
./scripts/init.sh github.com/myorg/my-project
```

### 2. 生成代码

```bash
# 生成 API 代码
make api

# 生成 RPC 代码
goctl rpc protoc rpc/proto/service.proto --go_out=rpc/pb --go-grpc_out=rpc/pb --zrpc_out=rpc/
```

### 3. 运行服务

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

## 服务类型

| 服务 | 说明 | 目录 |
|------|------|------|
| **API** | HTTP API 服务 | `api/` |
| **RPC** | Go-Zero zRPC 服务 | `rpc/` |
| **Job** | 定时任务服务 (K8S CronJob) | `job/` |
| **Consumer** | 消息消费者 (支持Kafka/TongLINK) | `consumer/` |

---

## 目录结构

```
.
├── .specify/                  # Spec Kit 配置
│   ├── memory/               # 项目宪法
│   └── templates/            # 需求/设计/任务模板
├── .github/prompts/          # AI 提示词
├── sdd_doc/spec/             # 规范文档
│
├── api/                      # HTTP API 服务
│   ├── api.go               # 入口文件
│   ├── doc/                 # API 定义
│   ├── etc/                 # 配置
│   └── internal/            # 内部代码
│
├── rpc/                      # gRPC 服务
│   ├── rpc.go               # 入口文件
│   ├── proto/               # protobuf 定义
│   ├── etc/                 # 配置
│   └── internal/            # 内部代码
│
├── job/                      # 定时任务服务
│   ├── job.go               # 入口文件
│   ├── etc/                 # 配置
│   └── internal/            # 内部代码
│
├── consumer/                 # 消息消费者服务
│   ├── consumer.go          # 入口文件
│   ├── etc/                 # 配置
│   └── internal/
│       ├── mq/              # MQ 抽象层
│       └── handler/         # 消息处理器
│
├── pkg/                      # 公共包
│   ├── middleware/          # 中间件
│   ├── response/            # 响应处理
│   ├── telemetry/           # 遥测
│   └── validator/           # 验证器
│
├── model/                    # Model 层
├── migrations/               # 数据库迁移
├── deploy/                   # 部署配置 (开发中)
│   ├── docker/              # Docker 配置
│   └── helm/                # Helm Chart
│
├── .cursorrules              # Cursor 配置
└── CLAUDE.md                 # Claude 配置
```

---

## 开发流程

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

详见：[Claude Code 开发指导](doc/claude-code-guide.md) | [Cursor + Spec-Kit 指导](doc/cursor-speckit-guide.md)

---

## 命令参考

```bash
# 项目初始化
./scripts/init.sh github.com/myorg/my-project

# 代码生成
make api           # 生成 API 代码

# 开发
make lint          # 代码检查
make test          # 运行测试
make build         # 编译

# 运行服务
go run api/api.go -f api/etc/api.yaml
go run rpc/rpc.go -f rpc/etc/rpc.yaml
```

---

## 文档

| 文档 | 说明 |
|------|------|
| [分层架构](sdd_doc/spec/architecture/layered-architecture.md) | Handler/Logic/Model 架构规范 |
| [API 服务指南](sdd_doc/spec/architecture/api-service-guide.md) | API 服务开发指南 |
| [命名规范](sdd_doc/spec/coding-standards/naming-conventions.md) | Go 代码命名规范 |
| [Claude Code 指导](doc/claude-code-guide.md) | AI 辅助开发完整指南 |
| [Cursor + Spec-Kit 指导](doc/cursor-speckit-guide.md) | Cursor 斜杠命令指南 |
| [用户认证示例](doc/examples/user-auth-workflow.md) | 5 阶段完整开发示例 |

---

## 消息队列支持

Consumer 服务支持多种消息中间件，通过抽象接口统一调用：

| 类型 | 状态 | 说明 |
|------|------|------|
| Kafka | ✅ | 基于 go-zero kq |
| TongLINK/Q-CN | 🚧 | 国产消息中间件，占位 |
| Redis Stream | 📋 | 计划中 |

---

## License

MIT
