# 场景一：新项目新功能 - 完整工作流

> **Version**: 1.0.0  
> **Created**: 2026-01-02  
> **Scenario**: New Feature Development

---

## 概述

本文档定义了**从零开始开发新功能**的完整 5 阶段工作流。适用于：

- 全新项目的首个功能
- 现有项目中的全新功能模块
- 没有任何已有 spec/plan/tasks 文档的场景

---

## 适用条件

使用此工作流的判断标准：

| 条件 | 状态 |
|------|------|
| `specs/{feature}/` 目录 | ❌ 不存在 |
| 已有 spec.md | ❌ 不存在 |
| 功能类型 | 🆕 全新功能 |
| 预期变更规模 | 大 |

---

## 工作流总览

```
Phase 1: Constitution (项目原则)    ← 仅首次需要
    ↓
Phase 2: Specify (需求规范)
    ↓ ⚠️ 人工检查点
Phase 3: Plan (技术设计)
    ↓ ⚠️ 人工检查点
Phase 4: Tasks (任务拆分)
    ↓ ⚠️ 人工检查点
Phase 5: Implement (执行实现)
```

---

## Phase 1: Constitution（项目原则）

> **仅首次需要**：如果 `.specify/memory/constitution.md` 已存在，跳过此阶段

### 目标

建立项目的核心原则和技术栈规范，作为所有后续开发的基础。

### 输入

- 项目背景和目标
- 技术栈选择（Go-Zero、MySQL 等）
- 团队约定

### 输出

**文件**: `.specify/memory/constitution.md`

### 模板

使用 `@.specify/templates/constitution-template.md`

### 检查清单

- [ ] 项目目标明确
- [ ] 技术栈确定
- [ ] 编码规范定义
- [ ] 架构原则确立

---

## Phase 2: Specify（需求规范）

### 目标

定义清晰的业务需求和验收标准，不包含技术实现细节。

### 输入

- 功能需求描述
- 用户故事
- `.specify/memory/constitution.md`（参考）

### 输出

**文件**: `specs/{feature}/spec.md`

### 模板

使用 `@.specify/templates/spec-template.md`

### 核心内容

1. **User Stories**（用户故事）
   ```
   AS a [角色]
   I WANT [功能]
   SO THAT [价值]
   ```

2. **Acceptance Criteria**（验收标准 - EARS 表示法）
   ```
   WHEN [条件]
   THE SYSTEM SHALL [行为]
   ```

3. **Business Rules**（业务规则）
   - 数据约束（唯一性、范围等）
   - 业务逻辑约束

4. **Data Considerations**（数据考量）
   - 需要持久化的数据描述
   - **不是表结构设计**

### 检查清单

- [ ] User Stories 完整
- [ ] 使用 EARS 表示法
- [ ] 业务规则明确
- [ ] 数据考量清晰
- [ ] **不包含技术实现细节**

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

完成 Phase 2 后：
1. 向用户展示 `spec.md`
2. 等待用户审批
3. **禁止自动进入 Phase 3**

---

## Phase 3: Plan（技术设计）

### 目标

基于需求规范，创建详细的技术实现方案。

### 输入

- `specs/{feature}/spec.md`
- `.specify/memory/constitution.md`

### 输出

**文件**: `specs/{feature}/plan.md`

### 模板

使用 `@.specify/templates/plan-template.md`

### 核心内容

1. **API 文件定义**
   - 位置：`api/doc/{module}/{feature}.api`
   - 遵循 Go-Zero API 语法

2. **DDL 文件定义**
   - 位置：`migrations/{module}/{table}.sql`
   - 包含完整的建表语句

3. **Model 接口设计**
   - 位置：`model/{module}/{table}/`
   - 定义 CRUD 接口

4. **文件产出清单**
   - 列出所有需要创建的文件

### goctl 命令

> ⚠️ **重要**：必须使用统一的 `api/doc/api.api` 入口文件！

```bash
# 步骤1：在 api/doc/api.api 中 import 新模块
# 步骤2：执行 goctl 生成代码
goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
```

### 检查清单

- [ ] API 文件定义完整
- [ ] DDL 文件定义完整
- [ ] Model 接口设计清晰
- [ ] 符合分层架构
- [ ] 文件清单完整

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

完成 Phase 3 后：
1. 向用户展示 `plan.md`、`.api`、`.sql` 文件
2. 等待用户审批
3. **禁止自动进入 Phase 4**

---

## Phase 4: Tasks（任务拆分）

### 目标

将技术设计拆分为可执行的小任务，每个任务 < 50 行代码。

### 输入

- `specs/{feature}/plan.md`

### 输出

**文件**: `specs/{feature}/tasks.md`

### 模板

使用 `@.specify/templates/tasks-template.md`

### 任务格式

```markdown
## Task 1: [任务描述]

**Status**: Not Started
**Depends on**: -
**Estimated Lines**: 30

**Files**:
- `path/to/file1.go`
- `path/to/file2.go`

**Acceptance Criteria**:
- [ ] 条件 1
- [ ] 条件 2
```

### 任务类型

| 类型 | 前缀 | 说明 |
|------|------|------|
| 模型层 | T-MOD | Model 相关任务 |
| 逻辑层 | T-LOG | Logic 相关任务 |
| 处理层 | T-HDL | Handler 相关任务 |
| 测试 | T-TST | 测试相关任务 |
| 其他 | T-OTH | 其他任务 |

### 检查清单

- [ ] 每个 Task < 50 行
- [ ] 依赖关系清晰
- [ ] 验收标准明确
- [ ] 涵盖所有必要文件

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

完成 Phase 4 后：
1. 向用户展示 `tasks.md`
2. 等待用户审批
3. **禁止自动进入 Phase 5**

---

## Phase 5: Implement（执行实现）

### 目标

按照任务清单，逐一实现功能。

### 输入

- `specs/{feature}/tasks.md`

### 输出

- 完整的代码实现
- 单元测试
- 集成测试

### 执行流程

1. **生成代码框架**
   ```bash
   # 在 api/doc/api.api 中 import 新模块后执行
   goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
   ```

2. **生成 Model 代码**
   ```bash
   goctl model mysql ddl -src migrations/{module}/{table}.sql \
     -dir model/{module}/{name}/ --style=go_zero
   ```

3. **逐个实施 Task**
   - 按依赖顺序执行
   - 每完成一个 Task，更新状态
   - 编写对应测试

4. **验证功能**
   - 运行单元测试
   - 运行集成测试
   - 手动验证

### 质量标准

- [ ] 编译通过
- [ ] 测试通过 (> 80%)
- [ ] Lint 无错误
- [ ] 函数不超过 50 行
- [ ] 使用中文注释
- [ ] 符合分层架构

---

## 工具触发方式

| 工具 | 命令 | 说明 |
|------|------|------|
| **Cursor** | `/speckit-scenario-new` | 单命令引导完整流程 |
| **Claude Code** | `/speckit.scenario.new` | 命令模式 |
| **Claude Code** | Prompt 选择器 | Prompt 模式 |
| **手动** | 查阅本文档 | 无 AI 工具时 |

---

## 文件产出清单

完成此工作流后，将产出以下文件：

```
specs/{feature}/
├── spec.md          # 需求规范
├── plan.md          # 技术设计
└── tasks.md         # 任务清单

api/doc/{module}/
└── {feature}.api    # API 定义

migrations/{module}/
└── {table}.sql      # DDL 定义

model/{module}/{table}/
├── model.go         # Model 接口
└── {table}_model.go # Model 实现

api/internal/
├── handler/{module}/ # Handler 层（goctl 生成）
├── logic/{module}/   # Logic 层（手动实现）
└── types/           # 类型定义（goctl 生成）
```

---

## 常见问题

### Q: 如果中途需要修改需求怎么办？

A: 根据修改规模选择场景：
- 小改动 → 场景二
- 功能扩展 → 场景三
- 大规模调整 → 场景四

### Q: 可以跳过某些阶段吗？

A: 
- Constitution 可跳过（如果已存在）
- 其他阶段不建议跳过
- 每个阶段都有人工检查点，确保质量

### Q: 任务拆分粒度如何把握？

A:
- 每个任务 < 50 行代码
- 每个任务可独立测试
- 依赖关系清晰

---

## 参考文档

- [场景选择决策树](./README.md)
- [场景二：小改动](./scenario-2-update.md)
- [场景三：功能扩展](./scenario-3-extend.md)
- [场景四：大规模重构](./scenario-4-refactor.md)
- [效益分析](../doc/scenarios/benefits-analysis.md)
