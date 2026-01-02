# Spec-Kit Scenario: Minor Update

引导用户对已有功能进行小规模修改。

---

## 场景识别

此场景适用于：
- `specs/{feature}/` 目录已存在
- 变更规模 < 50 行代码
- 不涉及新接口或数据库变更
- Bug 修复、参数调整、性能优化

---

## 工作流

按照 `@.specify/workflows/scenario-2-update.md` 中的定义执行。

### Step 1: 识别改动点

1. 询问用户要修改的功能名称
2. 阅读现有文档：
   - `specs/{feature}/spec.md`
   - `specs/{feature}/plan.md`
   - `specs/{feature}/tasks.md`
3. 定位需要修改的代码位置
4. 确认变更范围 < 50 行

### Step 2: 更新 tasks.md

在 `specs/{feature}/tasks.md` 末尾添加修复任务：

```markdown
---

## Task N: [Bug Fix / Minor Update] 任务描述

**Status**: Not Started
**Depends on**: -
**Estimated Lines**: [数量]
**Type**: 🔧 Minor Update

**Issue**: 
[问题描述]

**Files**:
- [涉及文件列表]

**Changes**:
- [具体修改内容]

**Acceptance Criteria**:
- [ ] 问题已修复
- [ ] 测试通过
- [ ] 不影响现有功能
```

### Step 3: 执行实现

1. 按任务描述修改代码
2. 运行测试验证
3. 更新任务状态为 Completed

### Step 4: 更新版本历史

在 `specs/{feature}/spec.md` 的 Revision History 表格中添加记录。

---

## 快速路径

此场景通常可在 30 分钟内完成：

```
识别问题 → 添加任务 → 修改代码 → 测试 → 更新历史
```

---

## 升级条件

如果发现以下情况，请升级到其他场景：

- 需要新接口 → 升级到场景三 `/speckit-scenario-extend`
- 需要修改数据库 → 升级到场景三 `/speckit-scenario-extend`
- 涉及破坏性变更 → 升级到场景四 `/speckit-scenario-refactor`

---

## Important

- 确认变更范围 < 50 行再继续
- 不需要更新 spec.md（除了版本历史）
- 不需要重新生成代码框架
- 修改完成后一定要更新任务状态
