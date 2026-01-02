# 场景二：已有功能小改动 - 增量更新工作流

> **Version**: 1.0.0  
> **Created**: 2026-01-02  
> **Scenario**: Minor Update / Bug Fix

---

## 概述

本文档定义了**对已有功能进行小规模修改**的快速工作流。适用于：

- Bug 修复
- 小功能调整
- 参数优化
- 性能优化
- UI 微调

---

## 适用条件

使用此工作流的判断标准：

| 条件 | 状态 |
|------|------|
| `specs/{feature}/` 目录 | ✅ 存在 |
| 已有 spec.md | ✅ 存在 |
| 变更规模 | 🔧 小（< 50 行代码） |
| 是否涉及新需求 | ❌ 否 |
| 是否涉及架构变更 | ❌ 否 |

---

## 工作流总览

```
Step 1: 识别改动点
    ↓
Step 2: 更新 tasks.md（添加修复任务）
    ↓
Step 3: 执行实现
    ↓
Step 4: 更新版本历史
```

> ⚡ **快速路径**：此场景通常可以在 30 分钟内完成

---

## Step 1: 识别改动点

### 目标

定位需要修改的文件和代码位置。

### 输入

- 问题描述 / 变更需求
- 现有 `specs/{feature}/` 文档

### 活动

1. **阅读现有文档**
   - `specs/{feature}/spec.md` - 理解业务需求
   - `specs/{feature}/plan.md` - 理解技术设计
   - `specs/{feature}/tasks.md` - 查看已完成的任务

2. **定位相关代码**
   - Handler 层：`api/internal/handler/{module}/`
   - Logic 层：`api/internal/logic/{module}/`
   - Model 层：`model/{module}/{table}/`

3. **评估影响范围**
   - 确认变更不涉及接口变化
   - 确认变更不涉及数据库变更
   - 确认变更范围 < 50 行

### 输出

- 问题定位
- 需要修改的文件清单
- 影响范围评估

### 检查清单

- [ ] 已理解现有功能
- [ ] 已定位问题/变更点
- [ ] 确认范围 < 50 行
- [ ] 确认不涉及接口/数据库变更

---

## Step 2: 更新 tasks.md

### 目标

在现有任务清单中添加修复/调整任务。

### 输入

- Step 1 的问题定位
- 现有 `specs/{feature}/tasks.md`

### 活动

在 `tasks.md` 末尾添加新任务：

```markdown
---

## Task N: [Bug Fix / Minor Update] 任务描述

**Status**: Not Started
**Depends on**: -
**Estimated Lines**: 15
**Type**: 🔧 Minor Update

**Issue**: 
简述问题或变更原因

**Files**:
- `api/internal/logic/{module}/{file}.go`

**Changes**:
- 描述具体要做的修改

**Acceptance Criteria**:
- [ ] 问题已修复
- [ ] 测试通过
- [ ] 不影响现有功能
```

### 输出

- 更新后的 `specs/{feature}/tasks.md`

### 检查清单

- [ ] 任务描述清晰
- [ ] 涉及文件明确
- [ ] 验收标准可验证

---

## Step 3: 执行实现

### 目标

按照任务描述完成修改。

### 输入

- 新添加的任务

### 活动

1. **修改代码**
   - 按任务描述修改
   - 保持代码风格一致
   - 添加/更新注释

2. **运行测试**
   ```bash
   # 运行相关测试
   go test ./api/internal/logic/{module}/... -v
   ```

3. **验证修复**
   - 确认问题已解决
   - 确认不影响其他功能

4. **更新任务状态**
   - 将任务状态改为 `Completed`
   - 标记验收标准已完成

### 输出

- 修改后的代码
- 通过的测试
- 更新后的任务状态

### 检查清单

- [ ] 代码修改正确
- [ ] 测试通过
- [ ] 任务状态已更新

---

## Step 4: 更新版本历史

### 目标

记录变更，便于追溯。

### 活动

在 `spec.md` 末尾的 Revision History 表格中添加记录：

```markdown
## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | xxx | 初始版本 |
| 1.1 | 2026-01-02 | xxx | 修复登录超时问题 |  ← 新增
```

### 输出

- 更新后的 `specs/{feature}/spec.md`（版本历史部分）

---

## 工具触发方式

| 工具 | 命令 | 说明 |
|------|------|------|
| **Cursor** | `/speckit-scenario-update` | 快速更新流程 |
| **Claude Code** | `/speckit.scenario.update` | 命令模式 |
| **手动** | 查阅本文档 | 无 AI 工具时 |

---

## 示例：修复登录超时问题

### Step 1: 识别改动点

```
问题：用户反馈登录时偶尔超时
定位：api/internal/logic/user/login_logic.go
原因：HTTP 请求超时时间设置过短
范围：约 5 行代码
```

### Step 2: 更新 tasks.md

```markdown
## Task 8: [Bug Fix] 修复登录超时问题

**Status**: Not Started
**Depends on**: -
**Estimated Lines**: 5
**Type**: 🔧 Bug Fix

**Issue**: 
登录接口偶发超时，原因是 HTTP 请求超时时间设置为 3 秒，
在网络波动时不够用。

**Files**:
- `api/internal/logic/user/login_logic.go`

**Changes**:
- 将超时时间从 3 秒调整为 10 秒

**Acceptance Criteria**:
- [ ] 超时时间已调整
- [ ] 测试通过
- [ ] 线上验证无超时问题
```

### Step 3: 执行实现

```go
// login_logic.go
// 修改前
client := &http.Client{Timeout: 3 * time.Second}

// 修改后
client := &http.Client{Timeout: 10 * time.Second}
```

### Step 4: 更新版本历史

```markdown
| 1.1 | 2026-01-02 | xxx | 修复登录超时问题（调整超时时间） |
```

---

## 与其他场景的边界

### 何时升级到场景三（功能扩展）？

- 需要添加新的 API 接口
- 需要添加新的数据库字段
- 变更超过 50 行代码

### 何时升级到场景四（重构）？

- 需要修改接口签名
- 需要修改数据库结构
- 涉及多个模块联动修改

---

## 常见问题

### Q: 如何判断是小改动还是功能扩展？

A: 使用以下标准：
- 代码量 < 50 行 → 小改动
- 不涉及新接口 → 小改动
- 不涉及数据库变更 → 小改动

### Q: 需要更新 spec.md 吗？

A: 
- 如果是 Bug 修复：通常不需要
- 如果是小调整：视情况更新描述
- 都需要更新 Revision History

### Q: 需要重新生成代码吗？

A: 
- 如果不涉及接口变更：不需要
- 如果涉及：升级到场景三

---

## 参考文档

- [场景选择决策树](./README.md)
- [场景一：新功能](./scenario-1-new.md)
- [场景三：功能扩展](./scenario-3-extend.md)
- [场景四：大规模重构](./scenario-4-refactor.md)
