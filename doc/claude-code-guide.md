# Claude Code + Spec 开发指导手册

> **Version**: 1.0.0  
> **Last Updated**: 2025-12-31  
> **适用范围**: IDRM 项目及基于本模板的所有项目

---

## 目录

1. [概述](#概述)
2. [环境准备](#环境准备)
3. [核心理念](#核心理念)
4. [5 阶段工作流详解](#5-阶段工作流详解)
5. [Prompt 最佳实践](#prompt-最佳实践)
6. [常见场景示例](#常见场景示例)
7. [故障排除](#故障排除)
8. [附录](#附录)

---

## 概述

### 什么是 Claude Code + Spec 开发模式？

这是一种 **AI 辅助的规范驱动开发（Spec-Driven Development）** 方法，结合了：

| 组件 | 作用 |
|------|------|
| **Claude Code** | AI 编码助手，理解上下文并生成代码 |
| **Spec 规范** | 定义项目标准、架构和工作流程 |
| **5 阶段工作流** | 确保开发过程可控、质量可保证 |

### 为什么采用这种模式？

```
传统开发：需求 → 编码 → 测试 → 出问题 → 重构
Spec 驱动：需求 → 规范化 → 设计 → 任务拆分 → 编码 → 高质量交付
```

**核心优势**：
- ✅ **减少返工**：提前发现问题
- ✅ **可预测性**：每个阶段有明确输出
- ✅ **质量保证**：内置质量门禁
- ✅ **团队协作**：标准化的交付物

---

## 环境准备

### 1. 工具安装

```bash
# Go 环境 (1.21+)
go version

# Go-Zero 工具
go install github.com/zeromicro/go-zero/tools/goctl@latest
goctl --version

# 代码质量
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### 2. 项目配置文件

确保项目根目录包含以下配置：

| 文件 | 作用 |
|------|------|
| `CLAUDE.md` | Claude 的项目上下文指南 |
| `.cursorrules` | Cursor 编辑器规则 |
| `.specify/` | Spec 模板和记忆文件 |
| `sdd_doc/spec/` | 项目规范文档 |

### 3. AI 工具配置

**Cursor 配置**：
```
Settings → Features → Enable Claude
Settings → Context → Include project files
```

**Claude CLI** (可选)：
```bash
# 安装 Claude CLI
npm install -g @anthropic-ai/claude-cli

# 配置 API Key
claude config set api_key YOUR_API_KEY
```

### 4. Spec-Kit 集成 (推荐)

本项目兼容 [GitHub Spec-Kit](https://github.com/github/spec-kit)，可使用其斜杠命令简化工作流。

> **重要**：模板已包含完整的 `.specify/` 配置，无需重新初始化！

#### 安装 Specify CLI（可选）

仅当你想使用 `/speckit.*` 斜杠命令时才需要安装：

```bash
# 方式 1: 持久安装 (推荐)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 方式 2: 一次性使用
uvx --from git+https://github.com/github/spec-kit.git specify check
```

#### 验证配置

```bash
# 检查配置（不会修改文件）
specify check

# 查看模板是否已包含
ls -la .specify/
```

> ⚠️ **警告**：不要运行 `specify init`，会覆盖模板的 `.specify/` 配置！

#### Spec-Kit 斜杠命令

初始化后，在 Claude Code 中可使用以下命令：

| 命令 | 说明 | 对应阶段 |
|------|------|----------|
| `/speckit.constitution` | 创建项目原则和开发准则 | Phase 0 增强 |
| `/speckit.specify` | 描述需要构建的功能 (What & Why) | Phase 1 |
| `/speckit.plan` | 生成技术实现计划 | Phase 2 |
| `/speckit.tasks` | 拆分为可执行任务列表 | Phase 3 |
| `/speckit.implement` | 执行任务并构建功能 | Phase 4 |
| `/speckit.clarify` | 澄清规格中的模糊点 | 可选 |
| `/speckit.checklist` | 生成验证清单 | 可选 |

#### 使用示例

```bash
# 1. 创建项目原则
/speckit.constitution Create principles focused on code quality, testing standards, and Go-Zero best practices

# 2. 描述功能需求
/speckit.specify Build a user authentication system with phone number registration and JWT login

# 3. 生成技术计划
/speckit.plan Use Go-Zero framework with MySQL, follow layered architecture (Handler → Logic → Model)

# 4. 生成任务列表
/speckit.tasks

# 5. 执行实现
/speckit.implement
```

#### Spec-Kit vs IDRM 5 阶段对照

| Spec-Kit 命令 | IDRM Phase | 输出物 |
|---------------|------------|--------|
| `/speckit.constitution` | Phase 0: Context | `.specify/memory/constitution.md` |
| `/speckit.specify` | Phase 1: Specify | `spec.md` |
| `/speckit.plan` | Phase 2: Design | `plan.md` |
| `/speckit.tasks` | Phase 3: Tasks | `tasks.md` |
| `/speckit.implement` | Phase 4: Implement | 代码实现 |

> **提示**: Spec-Kit 命令与 IDRM 5 阶段工作流完全一致，可混合使用。已有的模板文件（`.specify/templates/`）可与 Spec-Kit 斜杠命令配合使用。

#### 使用方式对比：Spec-Kit CLI vs 直接使用模板

本项目支持 **两种使用方式**，您可以根据偏好自由选择：

| 使用方式 | 适用场景 | 操作示例 |
|---------|----------|----------|
| **方式 1: Spec-Kit CLI** | 喜欢自动化，使用 Cursor | 输入 `/speckit.specify` 命令 |
| **方式 2: 直接引用模板** | 使用 Claude Code，灵活控制 | "请按照 `.specify/templates/requirements-template.md` 创建需求规范" |

**方式 1 示例（Spec-Kit CLI）**：
```
用户: /speckit.specify 创建用户认证功能规范
AI:   [自动打开模板，引导填写字段，生成 spec.md]
```

**方式 2 示例（直接使用模板）**：
```
用户: 请按照 .specify/templates/requirements-template.md 
     创建用户认证功能的需求规范

Claude: [读取模板文件，生成符合规范的 requirements_user_auth.md]
```

**关键差异**：

| 对比项 | Spec-Kit CLI | 直接使用模板 |
|--------|-------------|-------------|
| **环境依赖** | 需安装 `specify-cli` | 无需安装 |
| **操作方式** | 斜杠命令 `/speckit.*` | 提示词引用模板路径 |
| **自动化程度** | 高，自动引导填写 | 需手动说明需求 |
| **灵活性** | 固定流程 | 可自由调整 |
| **学习成本** | 需熟悉命令 | 需熟悉模板结构 |
| **输出文档** | 标准化命名 | 可自定义命名 |

**两种方式生成的文档格式完全一致**，可在团队内混用。

**推荐选择**：
- **Cursor 用户**：推荐方式 1（Spec-Kit CLI），体验更佳
- **Claude Code 用户**：推荐方式 2（直接使用模板），更灵活
- **混合团队**：两种方式都支持，按个人偏好

---

## 核心理念

### 1. 规范先行

```
❌ 错误做法：直接让 AI 写代码
✅ 正确做法：先让 AI 理解规范，再按流程开发
```

### 2. 分阶段执行

每个阶段都有**明确的输入、活动和输出**，阶段之间通过**人工检查点**连接。

```
Phase 0 → ⚠️ 确认 → Phase 1 → ⚠️ 确认 → Phase 2 → ⚠️ 确认 → Phase 3 → ⚠️ 确认 → Phase 4
```

### 3. EARS 标注法

使用标准化的需求描述格式：

```markdown
WHEN [条件/事件]
THE SYSTEM SHALL [预期行为]
```

**示例**：
```markdown
WHEN 用户提交有效的创建请求
THE SYSTEM SHALL 保存数据并返回 201 状态码
```

### 4. 质量门禁

每个阶段必须通过质量检查才能进入下一阶段：

| 阶段 | 门禁检查 |
|------|----------|
| Phase 1 | 需求完整、EARS 格式正确 |
| Phase 2 | 架构合规、接口定义清晰 |
| Phase 3 | 任务 <50 行、依赖明确 |
| Phase 4 | 编译通过、测试 >80%、Lint 无错误 |

---

## 5 阶段工作流详解

### Phase 0: Context（上下文准备）

**目标**：理解项目规范和当前开发上下文

**Prompt 模板**：
```
我需要开发 [功能名称]。

请先执行 Phase 0: Context：
1. 阅读 sdd_doc/spec/core/ 下的规范文档
2. 了解项目的分层架构要求
3. 熟悉编码标准

完成后，告诉我你对项目规范的理解。
```

**输出**：
- 对项目规范的理解总结
- 开发环境准备状态

**检查清单**：
- [ ] 已阅读 project-charter.md
- [ ] 已了解分层架构
- [ ] 已熟悉编码标准
- [ ] 开发环境就绪

---

### Phase 1: Specify（需求规范）

**目标**：定义清晰的业务需求和验收标准

**Prompt 模板**：
```
继续执行 Phase 1: Specify

功能需求：[描述功能需求]

请生成 specs/features/{feature-name}/spec.md，包含：
1. User Stories（AS/I WANT/SO THAT 格式）
2. Acceptance Criteria（EARS 格式表格）
3. Edge Cases
4. Business Rules
5. Data Considerations

使用 .specify/templates/spec-template.md 模板。
```

**输出**：`specs/features/{feature-name}/spec.md`

**格式示例**：
```markdown
## User Stories

### Story 1: 创建资源 (P1)

AS a 管理员
I WANT 创建新的资源分类
SO THAT 可以对资源进行分类管理

## Acceptance Criteria (EARS)

| ID | Scenario | Trigger | Expected Behavior |
|----|----------|---------|-------------------|
| AC-01 | 创建成功 | WHEN 提交有效数据 | THE SYSTEM SHALL 保存并返回 201 |
| AC-02 | 参数为空 | WHEN 必填参数为空 | THE SYSTEM SHALL 返回 400 |
```

**检查清单**：
- [ ] User Stories 完整（AS/I WANT/SO THAT）
- [ ] 验收标准使用 EARS 格式
- [ ] 业务规则明确
- [ ] **不包含技术实现细节**

---

### Phase 2: Design（技术设计）

**目标**：创建详细的技术方案

**Prompt 模板**：
```
继续执行 Phase 2: Design

基于 specs/features/{feature-name}/spec.md，请生成 plan.md：
1. 遵循分层架构（Handler → Logic → Model）
2. 列出需要创建/修改的文件
3. 定义接口（Model interface）
4. 绘制序列图

参考 sdd_doc/spec/architecture/layered-architecture.md 的架构规范。
```

**输出**：`specs/features/{feature-name}/plan.md`

**格式示例**：
```markdown
## File Structure

```
model/category/
├── interface.go      # Model 接口定义
├── types.go          # 数据类型
├── gorm_dao.go       # GORM 实现
└── category_test.go  # 单元测试

api/internal/
├── handler/category/
│   └── category_handler.go
└── logic/category/
    ├── create_category_logic.go
    └── get_category_logic.go
```

## Interface Definitions

```go
type CategoryModel interface {
    Create(ctx context.Context, data *Category) error
    FindOne(ctx context.Context, id int64) (*Category, error)
    // ...
}
```
```

**检查清单**：
- [ ] 符合分层架构
- [ ] 文件清单完整
- [ ] 接口定义清晰
- [ ] Handler ≤30 行，Logic ≤50 行，Model ≤50 行

---

### Phase 3: Tasks（任务拆分）

**目标**：将设计拆分为可执行的小任务

**Prompt 模板**：
```
继续执行 Phase 3: Tasks

基于 plan.md，请生成 tasks.md：
1. 每个任务代码量 <50 行
2. 标明任务依赖关系
3. 标注可并行任务 [P]
4. 定义每个任务的验收标准

使用 .specify/templates/tasks-template.md 模板。
```

**输出**：`specs/features/{feature-name}/tasks.md`

**格式示例**：
```markdown
## Task Overview

| ID | Task | Story | Status | Parallel | Est. Lines |
|----|------|-------|--------|----------|------------|
| T001 | 创建 API 文件 | US1 | ⏸️ | - | 30 |
| T002 | 生成代码框架 | US1 | ⏸️ | - | - |
| T003 | Model 接口定义 | US1 | ⏸️ | [P] | 20 |
| T004 | GORM 实现 | US1 | ⏸️ | - | 50 |

## Phase 3: User Story 1

### Step 1: 定义 API
- [ ] T001 创建 api/doc/category/category.api
- [ ] T002 运行 goctl api go 生成代码
```

**检查清单**：
- [ ] 每个任务 <50 行
- [ ] 依赖关系清晰
- [ ] 验收标准明确
- [ ] 可并行任务标注 [P]

---

### Phase 4: Implement（实施验证）

**目标**：逐个实现任务，测试验证

**Prompt 模板**：
```
继续执行 Phase 4: Implement

请按照 tasks.md 逐个实现：

当前任务：T001 - 创建 API 文件

完成后：
1. 更新 tasks.md 中的状态
2. 运行编译检查
3. 运行测试（如适用）
```

**活动**：
1. **生成代码框架**
   ```bash
   goctl api go -api api/doc/api.api -dir api/ --style=go_zero
   ```

2. **实现业务逻辑**
   - 按任务顺序实现
   - 每完成一个任务更新状态

3. **测试验证**
   ```bash
   go build ./...
   go test -cover ./...
   golangci-lint run
   ```

**质量门禁**：
- [ ] 编译通过
- [ ] 测试覆盖率 >80%
- [ ] Lint 无错误
- [ ] Code Review 通过

---

## Prompt 最佳实践

### 1. 开始新功能

```
@CLAUDE.md @sdd_doc/spec/core/workflow.md

我需要开发一个 [功能名称] 功能。

请严格按照 5 阶段工作流执行，先从 Phase 0 开始。
每完成一个阶段，请停止并等待我的确认。
```

### 2. 继续下一阶段

```
Phase 0 的输出已确认，请继续执行 Phase 1: Specify。

功能需求补充：
- [补充细节 1]
- [补充细节 2]
```

### 3. 修改需求

```
请修改 spec.md 中的以下内容：
- AC-01 的预期行为改为 [新行为]
- 添加一个新的 Edge Case: [描述]

修改后重新生成 spec.md，不要进入下一阶段。
```

### 4. 跳过某阶段（不推荐）

```
当前功能较简单，请快速执行 Phase 1-3，生成简化版的 spec/plan/tasks。

注意：仍需遵守核心规范（EARS 格式、分层架构等）。
```

### 5. 修复问题

```
在 Phase 4 实现过程中遇到问题：
[描述问题]

请分析原因并提供解决方案。如需修改设计，请说明。
```

---

## 常见场景示例

### 场景 1：新增 CRUD 功能

**对话示例**：

```
User: 我需要开发一个标签管理功能，支持标签的增删改查。

AI: 好的，我将执行 Phase 0: Context。

[阅读规范...]

✅ Phase 0 完成

我已了解：
- 项目采用 Go-Zero 分层架构
- Model 层支持 Dual ORM
- 需遵循 EARS 需求描述法

是否继续执行 Phase 1?

User: 继续

AI: 执行 Phase 1: Specify...

[生成 spec.md]

✅ Phase 1 完成

已生成 specs/features/tag-management/spec.md，包含：
- 4 个 User Stories
- 12 条验收标准
- 5 条业务规则

请确认需求是否完整，是否继续 Phase 2?
```

### 场景 2：API 优化

```
User: 现有的列表查询接口性能较差，需要优化。

AI: 执行 Phase 0: Context...

这是现有功能的优化，我建议：
- 方案 A：原地更新（小型改动）
- 方案 B：创建 v2 版本（大型重构）

请确认采用哪种方案？

User: 采用方案 A，主要是添加缓存。

AI: 好的，执行 Phase 1: Specify...

由于是优化类需求，我将：
1. 创建 specs/features/list-performance/spec.md
2. 重点描述性能需求和验收标准
```

### 场景 3：Bug 修复

```
User: 创建分类时，重复名称没有返回正确的错误码。

AI: 这是一个 Bug 修复场景。

我将：
1. 快速分析代码定位问题
2. 按 Phase 4 模式直接修复
3. 补充/更新相关测试

是否需要我直接分析并修复？

User: 是的

AI: [分析代码...]

问题定位：
- 位置：api/internal/logic/category/create_category_logic.go
- 原因：未正确处理唯一约束错误
- 修复方案：添加错误类型判断

正在修复...
```

---

## 故障排除

### 问题 1：AI 跳过阶段

**现象**：AI 直接开始写代码，没有按阶段执行

**解决**：
```
请停止当前操作。

这个项目要求严格按照 5 阶段工作流执行。
请重新从 Phase 0 开始，每个阶段结束后等待我的确认。

参考：@CLAUDE.md 中的"Agent Behavior Rules"
```

### 问题 2：生成的代码不符合规范

**现象**：生成的代码没有遵循分层架构

**解决**：
```
生成的代码不符合项目规范：
- 问题：Logic 层直接操作数据库
- 规范：Logic 层只应调用 Model 层接口

请参考 @sdd_doc/spec/architecture/layered-architecture.md 重新生成。
```

### 问题 3：需求描述不清

**现象**：生成的 spec.md 缺少关键信息

**解决**：
```
spec.md 缺少以下信息，请补充：
1. Edge Cases 中需要考虑并发创建场景
2. Business Rules 需明确最大嵌套层级
3. Data Considerations 需说明排序字段的默认值

补充后重新生成 spec.md。
```

### 问题 4：任务拆分过大

**现象**：单个任务代码量超过 50 行

**解决**：
```
T004 的预估代码量为 120 行，超过 50 行限制。

请将此任务拆分为 2-3 个子任务：
- 每个子任务 <50 行
- 明确子任务之间的依赖关系
- 更新 tasks.md
```

---

## 附录

### A. 关键文件速查表

| 文件 | 路径 | 用途 |
|------|------|------|
| Claude 指南 | `CLAUDE.md` | AI 工具的项目上下文 |
| 工作流定义 | `sdd_doc/spec/core/workflow.md` | 5 阶段工作流详细说明 |
| 分层架构 | `sdd_doc/spec/architecture/layered-architecture.md` | Handler/Logic/Model 规范 |
| Spec 模板 | `.specify/templates/spec-template.md` | Phase 1 输出模板 |
| Plan 模板 | `.specify/templates/plan-template.md` | Phase 2 输出模板 |
| Tasks 模板 | `.specify/templates/tasks-template.md` | Phase 3 输出模板 |

### B. 常用命令

```bash
# 代码生成
goctl api go -api api/doc/api.api -dir api/ --style=go_zero

# 编译检查
go build ./...

# 运行测试
go test -cover ./...

# 代码检查
golangci-lint run

# 生成测试覆盖率报告
go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out
```

### C. EARS 格式速查

| 类型 | 格式 | 示例 |
|------|------|------|
| 事件触发 | WHEN [event] THE SYSTEM SHALL [behavior] | WHEN 用户点击提交 THE SYSTEM SHALL 保存数据 |
| 条件判断 | IF [condition] WHEN [trigger] THE SYSTEM SHALL [behavior] | IF 用户已登录 WHEN 访问资源 THE SYSTEM SHALL 返回数据 |
| 始终执行 | THE SYSTEM SHALL [behavior] | THE SYSTEM SHALL 验证所有输入参数 |

### D. 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0.0 | 2025-12-31 | 初始版本 |

---

**维护者**: IDRM Team  
**问题反馈**: 请在项目仓库提交 Issue
