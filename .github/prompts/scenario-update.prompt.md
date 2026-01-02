# Scenario: Minor Update Workflow

引导用户对已有功能进行小规模修改。

---

## 场景识别

当满足以下条件时使用此工作流：
- `specs/{feature}/` 目录已存在
- 变更规模 < 50 行代码
- 不涉及新接口或数据库变更
- Bug 修复、参数调整、性能优化

---

## 工作流

按照 `.specify/workflows/scenario-2-update.md` 中的定义执行。

### Step 1: 识别改动点

1. 阅读现有文档
2. 定位问题/修改点
3. 确认范围 < 50 行

### Step 2: 更新 tasks.md

在末尾添加修复任务：

```markdown
## Task N: [Bug Fix] 描述

**Status**: Not Started
**Type**: 🔧 Minor Update
**Estimated Lines**: [数量]

**Files**:
- [文件列表]

**Acceptance Criteria**:
- [ ] 问题已修复
- [ ] 测试通过
```

### Step 3: 执行实现

1. 修改代码
2. 运行测试
3. 更新任务状态

### Step 4: 更新版本历史

更新 Revision History 表格。

---

## 升级条件

- 需要新接口 → 场景三
- 涉及破坏性变更 → 场景四
