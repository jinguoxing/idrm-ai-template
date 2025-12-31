# IDRM AI Template

> Go-Zero 项目模板，包含 AI 辅助开发规范

---

## 功能特点

- ✅ **Go-Zero 框架**：API 服务基础结构
- ✅ **Spec Kit 集成**：`.specify/` 模板和提示词
- ✅ **完整规范文档**：`sdd_doc/spec/` 开发规范
- ✅ **Telemetry 支持**：Logging、Tracing、Audit
- ✅ **公共包**：middleware、response、validator

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

### 2. 生成 API 代码

```bash
make api
```

### 3. 运行服务

```bash
go run api/api.go
```

---

## 目录结构

```
.
├── .specify/                  # Spec Kit 配置
│   ├── memory/               # 项目宪法
│   └── templates/            # 需求/设计/任务模板
├── .github/prompts/          # AI 提示词
├── sdd_doc/spec/             # 规范文档
├── api/                      # Go-Zero API
│   ├── api.go               # 入口文件
│   ├── doc/                 # API 定义
│   └── internal/            # 内部代码
├── pkg/                      # 公共包
│   ├── middleware/          # 中间件
│   ├── response/            # 响应处理
│   ├── telemetry/           # 遥测
│   └── validator/           # 验证器
├── model/                    # Model 层
├── migrations/               # 数据库迁移
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

---

## 命令参考

```bash
make init          # 初始化项目
make api           # 生成 API 代码
make lint          # 代码检查
make test          # 运行测试
make build         # 编译
```

---

## 相关文档

- [分层架构](sdd_doc/spec/architecture/layered-architecture.md)
- [API 服务指南](sdd_doc/spec/architecture/api-service-guide.md)
- [命名规范](sdd_doc/spec/coding-standards/naming-conventions.md)

---

## License

MIT
