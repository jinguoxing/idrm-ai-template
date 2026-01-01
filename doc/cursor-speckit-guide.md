# Cursor + Spec-Kit 开发指导手册

> **Version**: 1.0.0  
> **Last Updated**: 2025-12-31  
> **适用范围**: 使用 Cursor 编辑器 + Spec-Kit 进行 AI 辅助开发

---

## 目录

1. [概述](#概述)
2. [环境配置](#环境配置)
3. [Spec-Kit 斜杠命令速查](#spec-kit-斜杠命令速查)
4. [完整开发流程](#完整开发流程)
5. [场景演示：用户认证功能](#场景演示用户认证功能)
6. [场景演示：CRUD 功能开发](#场景演示crud-功能开发)
7. [最佳实践](#最佳实践)
8. [常见问题](#常见问题)

---

## 概述

**Cursor + Spec-Kit** 是一种高效的 AI 辅助开发组合：

| 工具 | 作用 |
|------|------|
| **Cursor** | AI 增强的代码编辑器，内置 Claude/GPT |
| **Spec-Kit** | GitHub 官方的规范驱动开发工具包 |

### 工作流程

```
/speckit.constitution → /speckit.specify → /speckit.plan → /speckit.tasks → /speckit.implement
        ↓                      ↓                 ↓               ↓                ↓
   项目原则              需求规范           技术设计        任务拆分          代码实现
```

---

## 环境配置

### 1. 安装 Cursor

从 [cursor.sh](https://cursor.sh) 下载并安装 Cursor 编辑器。

### 2. 安装 Spec-Kit CLI

```bash
# 需要先安装 uv (Python 包管理器)
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# 持久安装 Specify CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

### 3. 验证项目配置

本模板已预配置 Spec-Kit，**开箱即用**！

#### 检查配置

```bash
# 克隆或使用模板后，检查是否已包含配置
cd my-project
ls -la .specify/
ls -la .github/prompts/
ls -la .cursor/commands/

# .specify/ 应包含：
# ├── memory/
# │   └── constitution.md         # 项目原则
# └── templates/
#     ├── requirements-template.md # 需求模板
#     ├── design-template.md       # 设计模板
#     ├── tasks-template-v3.md     # 任务模板
#     ├── api-template.api         # API 模板
#     └── schema-template.sql      # 数据库模板

# .github/prompts/ 应包含（GitHub Copilot/Claude Code 用）：
# ├── constitution.prompt.md
# ├── specify.prompt.md
# ├── plan.prompt.md
# ├── tasks.prompt.md
# ├── implement.prompt.md
# └── clarify.prompt.md

# .cursor/commands/ 应包含（Cursor 斜杠命令）：
# ├── speckit-constitution.md
# ├── speckit-specify.md
# ├── speckit-plan.md
# ├── speckit-tasks.md
# ├── speckit-implement.md
# └── speckit-clarify.md
```

> ✅ **好消息**：模板已包含完整配置，**斜杠命令可直接使用**！
>
> - `.cursor/commands/` - Cursor 斜杠命令定义
> - `.github/prompts/` - GitHub Copilot/Claude Code 命令定义
> - `.specify/` - Spec-Kit 模板和配置
>
> 无需运行 `specify init`，所有配置已预置！

**在 Cursor 中使用斜杠命令**：

在 Cursor Chat 中输入 `/` 即可看到可用命令:
- `/speckit-constitution` - 创建项目原则
- `/speckit-specify` - 定义需求规范
- `/speckit-plan` - 生成技术设计
- `/speckit-tasks` - 拆分任务列表
- `/speckit-implement` - 执行代码实现
- `/speckit-clarify` - 澄清模糊点

**可选：安装 Specify CLI 工具（用于命令行操作）**

```bash
# 安装 Specify CLI 工具（可选，仅用于命令行）
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 验证配置（不会修改文件）
specify check
```

### 4. 在 Cursor 中配置

1. 打开项目：`File → Open Folder → 选择项目目录`
2. 确认 `.cursorrules` 文件存在（模板已包含）
3. 打开 Cursor Chat：`Cmd+L` (macOS) 或 `Ctrl+L` (Windows)

---

## Spec-Kit 斜杠命令速查

在 Cursor Chat 中可使用以下命令：

### 核心命令

| 命令 | 说明 | 输入 | 输出 |
|------|------|------|------|
| `/speckit.constitution` | 建立项目原则 | 质量/测试/架构要求 | `.specify/memory/constitution.md` |
| `/speckit.specify` | 定义功能规范 | 功能描述 (What & Why) | `spec.md` |
| `/speckit.plan` | 生成技术方案 | 技术栈和架构选择 | `plan.md` |
| `/speckit.tasks` | 拆分任务列表 | - | `tasks.md` |
| `/speckit.implement` | 执行实现 | - | 代码文件 |

### 可选命令

| 命令 | 说明 |
|------|------|
| `/speckit.clarify` | 澄清规格中的模糊点 |
| `/speckit.checklist` | 生成验证清单 |
| `/quizme` | AI 测试你对需求的理解 |
| `/speckit.analyze` | 分析代码质量 |

---

## 使用方式对比

本模板支持 **两种 Spec-Kit 使用方式**，您可以根据需求自由选择：

### 方式 1: Spec-Kit CLI 命令（推荐）

**适合**: Cursor 用户，追求自动化和标准化流程

**优点**:
- ✅ 斜杠命令 `/speckit.*` 快速调用
- ✅ 自动引导填写各个字段
- ✅ 标准化的文件命名和结构
- ✅ 内置验证和检查

**示例**:
```
用户: /speckit.specify 创建用户认证功能规范
AI:   [自动打开模板，引导填写字段，生成 spec.md]
```

**适用场景**: 新功能开发，需要完整的文档流程

---

### 方式 2: 直接使用模板文件

**适合**: 灵活控制，或无法安装 Spec-Kit CLI 的场景

**优点**:
- ✅ 无需安装 `specify-cli`
- ✅ 直接引用 `.specify/templates/` 中的模板
- ✅ 可自定义文档结构和命名
- ✅ 适合快速迭代和原型开发

**示例**:
```
用户: 请按照 .specify/templates/requirements-template.md 
     创建用户认证功能的需求规范

AI:   [读取模板文件，生成符合规范的 requirements_user_auth.md]
```

**适用场景**: 小功能修改、文档更新、快速验证想法

---

### 核心差异对比

| 对比项 | Spec-Kit CLI 命令 | 直接使用模板文件 |
|--------|------------------|------------------|
| **环境依赖** | 需安装 `uv` 和 `specify-cli` | 无需安装 |
| **调用方式** | `/speckit.*` 斜杠命令 | 提示词引用模板路径 |
| **自动化程度** | 高，自动引导和验证 | 低，需手动说明 |
| **文件命名** | 固定标准（`spec.md`, `plan.md`） | 可自定义 |
| **学习成本** | 需熟悉各命令用法 | 需了解模板结构 |
| **灵活性** | 固定流程 | 高度灵活 |
| **团队协作** | 易于统一标准 | 需约定规范 |

### 设计理念

```
              Spec-Kit CLI 命令
                     ↓
                 读取并处理
                     ↓
        .specify/ 模板文件  ←  AI 也可直接读取
                     ↓
                指导开发流程
```

**关键点**:
1. `.specify/` 中的模板文件是**自包含的知识库**
2. AI（Claude/Cursor）可以**直接理解和应用**这些模板
3. Spec-Kit CLI 是**增强工具**，非必需
4. 两种方式**生成的文档格式完全一致**，可混用

### 推荐选择

- **Cursor 新手**：方式 1，按流程学习
- **经验用户**：方式 2，快速开发
- **团队协作**：方式 1，统一标准
- **个人项目**：两种都可，看偏好

---

## 完整开发流程

### 步骤 1: 建立项目原则

在 Cursor Chat 中输入：

```
/speckit.constitution

请建立以下项目原则：
1. 代码质量：遵循 Go-Zero 最佳实践
2. 测试标准：核心逻辑覆盖率 > 80%
3. 架构规范：Handler → Logic → Model 分层
4. 错误处理：使用统一的错误码体系
```

**输出**：`.specify/memory/constitution.md`

---

### 步骤 2: 定义功能规范

```
/speckit.specify

开发一个用户认证功能：
- 用户可以使用手机号 + 密码注册
- 用户可以登录并获取 JWT Token
- 密码需要加密存储
- 登录失败需要返回明确的错误信息
```

**输出**：`spec.md`（包含 User Stories、验收标准、业务规则）

---

### 步骤 3: 生成技术方案

```
/speckit.plan

技术栈要求：
- 框架：Go-Zero v1.9+
- 数据库：MySQL 8.0
- 架构：分层架构（Handler ≤30行, Logic ≤50行, Model ≤50行）
- 密码加密：bcrypt
- Token：JWT，有效期 24 小时
```

**输出**：`plan.md`（包含文件结构、接口定义、序列图）

---

### 步骤 4: 拆分任务

```
/speckit.tasks
```

**输出**：`tasks.md`（每个任务 <50 行代码，带依赖关系）

---

### 步骤 5: 执行实现

```
/speckit.implement
```

AI 将按照 tasks.md 逐个实现任务，并更新进度。

---

## 场景演示：用户认证功能

### 完整对话示例

```
👤 User: 
/speckit.constitution

项目原则：
1. 使用 Go-Zero 框架，严格遵循分层架构
2. 代码风格遵循 IDRM 规范
3. 所有公共函数必须有中文注释
4. 测试覆盖率 > 80%

🤖 Cursor AI:
我将为你创建项目原则文件...

✅ 已创建 `.specify/memory/constitution.md`

项目原则已建立，包含：
- 架构规范：Go-Zero 分层架构
- 代码风格：IDRM 规范
- 文档要求：中文注释
- 质量标准：80% 测试覆盖

是否继续定义功能规范？

---

👤 User:
/speckit.specify

开发用户认证功能：用户注册（手机号+密码）和登录（返回JWT）

🤖 Cursor AI:
正在生成功能规范...

✅ 已创建 `spec.md`

## 功能概述
用户认证系统，支持手机号密码注册和 JWT 登录

## User Stories

### US1: 用户注册 (P1)
AS a 新用户
I WANT 使用手机号和密码注册
SO THAT 可以使用系统功能

### US2: 用户登录 (P1)  
AS a 已注册用户
I WANT 使用手机号和密码登录
SO THAT 获取访问令牌

## 验收标准
| ID | 场景 | 条件 | 预期行为 |
|----|------|------|----------|
| AC-01 | 注册成功 | WHEN 提交有效手机号和密码 | 返回 201 和用户ID |
| AC-02 | 手机号已存在 | WHEN 手机号已注册 | 返回 409 错误 |
| AC-03 | 登录成功 | WHEN 凭证正确 | 返回 200 和 Token |

[完整规范见 spec.md]

是否继续生成技术方案？

---

👤 User:
/speckit.plan

使用 Go-Zero + MySQL，bcrypt 加密，JWT 24小时有效

🤖 Cursor AI:
正在生成技术方案...

✅ 已创建 `plan.md`

## 文件结构
```
api/doc/user/user.api          # API 定义
api/internal/logic/user/       # 业务逻辑
model/user/                    # 数据模型
pkg/jwt/                       # JWT 工具
```

## 接口设计
- POST /api/v1/user/register
- POST /api/v1/user/login

## 序列图
[注册流程] User → Handler → Logic → Model → DB
[登录流程] User → Handler → Logic → Model → DB → JWT

[完整方案见 plan.md]

是否继续拆分任务？

---

👤 User:
/speckit.tasks

🤖 Cursor AI:
正在拆分任务...

✅ 已创建 `tasks.md`

## 任务列表
| ID | 任务 | 预估行数 | 状态 |
|----|------|----------|------|
| T01 | 创建 user.api | 40 | ⏸️ |
| T02 | 运行 goctl 生成代码 | - | ⏸️ |
| T03 | 创建 JWT 工具包 | 30 | ⏸️ |
| T04 | 创建 Model 接口 | 25 | ⏸️ |
| T05 | 实现 GORM DAO | 50 | ⏸️ |
| T06 | 实现注册 Logic | 45 | ⏸️ |
| T07 | 实现登录 Logic | 40 | ⏸️ |
| T08 | 编写单元测试 | 60 | ⏸️ |

总计 8 个任务，是否开始实现？

---

👤 User:
/speckit.implement

🤖 Cursor AI:
开始执行任务...

📝 T01: 创建 user.api
[生成代码...]
✅ 完成

📝 T02: 运行 goctl
[执行命令...]
✅ 完成

📝 T03-T08: [继续执行...]

✅ 所有任务完成！

## 实现摘要
- 创建文件：12 个
- 代码行数：~350 行
- 测试覆盖：85%

请运行以下命令验证：
```bash
go build ./...
go test -cover ./...
```
```

---

## 场景演示：CRUD 功能开发

### 快速开发标签管理功能

```
👤 User:
/speckit.specify

开发一个标签管理功能：
- 标签的增删改查
- 标签名称唯一
- 支持按名称搜索

🤖 Cursor AI:
正在生成规范...

✅ spec.md 已创建

包含：
- 4 个 User Stories (创建/查询/更新/删除)
- 12 条验收标准
- 3 条业务规则

---

👤 User:
/speckit.plan

Go-Zero 标准 CRUD，使用 GORM

🤖 Cursor AI:
✅ plan.md 已创建

文件结构：
- api/doc/tag/tag.api
- model/tag/
- api/internal/logic/tag/

---

👤 User:
/speckit.tasks

🤖 Cursor AI:
✅ tasks.md 已创建

10 个任务，预计 400 行代码

---

👤 User:
/speckit.implement

🤖 Cursor AI:
[执行所有任务...]

✅ 完成！标签管理功能已实现。
```

---

## 最佳实践

### 1. 先规范后实现

```
✅ 正确顺序：constitution → specify → plan → tasks → implement
❌ 错误做法：直接 /speckit.implement
```

### 2. 每阶段确认再继续

```
✅ 检查 spec.md 需求是否完整
✅ 检查 plan.md 架构是否合理
✅ 检查 tasks.md 任务是否可执行
```

### 3. 提供充足上下文

```
# 好的方式
/speckit.plan
使用 Go-Zero + MySQL + GORM，
遵循 Handler→Logic→Model 分层，
参考 sdd_doc/spec/architecture/layered-architecture.md

# 不好的方式
/speckit.plan
随便写
```

### 4. 结合项目规范

在 `/speckit.*` 命令中引用项目规范文件：

```
/speckit.specify

@CLAUDE.md @sdd_doc/spec/core/workflow.md

开发用户认证功能...
```

### 5. 分步实现复杂功能

```
# 复杂功能分多轮
/speckit.implement T01-T03   # 先实现基础设施
/speckit.implement T04-T06   # 再实现核心逻辑
/speckit.implement T07-T08   # 最后实现测试
```

---

## 常见问题

### Q1: 命令没有响应

**原因**：Spec-Kit 未正确初始化

**解决**：
```bash
# 重新初始化
specify init . --ai cursor-agent --force
```

### Q2: 生成的代码不符合规范

**原因**：未提供足够的上下文

**解决**：在命令中添加规范引用
```
/speckit.plan

@sdd_doc/spec/architecture/layered-architecture.md

使用 Go-Zero 分层架构...
```

### Q3: 任务太大无法完成

**原因**：任务拆分不够细

**解决**：
```
请重新拆分 T05，该任务预估 120 行代码，
需要拆分为 2-3 个子任务，每个 <50 行。
```

### Q4: 如何跳过某个阶段

**不推荐**，但可以：
```
# 如果已有 spec.md
/speckit.plan
```

### Q5: 如何修改已生成的规范

```
请修改 spec.md：
1. AC-01 行为改为 "返回 200 和完整用户信息"
2. 添加边界情况：并发注册同一手机号

修改后更新 plan.md 和 tasks.md
```

---

## 附录

### A. 命令参数速查

```bash
# 初始化项目
specify init . --ai cursor-agent

# 检查环境
specify check

# 升级 Spec-Kit
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

### B. 文件输出对照

| 命令 | 输出文件 |
|------|----------|
| `/speckit.constitution` | `.specify/memory/constitution.md` |
| `/speckit.specify` | `spec.md` |
| `/speckit.plan` | `plan.md` |
| `/speckit.tasks` | `tasks.md` |
| `/speckit.implement` | 代码文件 |
| `/speckit.checklist` | `checklist.md` |

### C. 相关资源

- [GitHub Spec-Kit](https://github.com/github/spec-kit)
- [Cursor 官网](https://cursor.sh)
- [Go-Zero 文档](https://go-zero.dev)

---

**Last Updated**: 2025-12-31
