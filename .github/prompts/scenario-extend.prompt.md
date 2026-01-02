# Scenario: Feature Extension Workflow

引导用户在已有功能基础上进行扩展。

---

## 场景识别

当满足以下条件时使用此工作流：
- `specs/{feature}/` 目录已存在
- 需要添加新的 User Story
- 可能涉及新 API 接口
- 向后兼容

---

## 工作流

按照 `.specify/workflows/scenario-3-extend.md` 中的定义执行。

### Step 1: 分析扩展点

1. 阅读现有文档
2. 确定扩展位置

### Step 2: 扩展 spec.md

添加新内容（使用 🆕 标记）：

```markdown
### Story N: [新功能] (P2) 🆕 扩展
AS a [角色]
I WANT [功能]
SO THAT [价值]
```

**⚠️ 停止等待确认**

### Step 3: 扩展 plan.md

1. 添加新 API 接口
2. 添加新 DDL 字段
3. 更新文件清单

**⚠️ 停止等待确认**

### Step 4: 更新 tasks.md

添加扩展任务组（Type: ➕ Extension）

**⚠️ 停止等待确认**

### Step 5: 执行实现

1. 执行数据库变更
2. 重新生成代码框架
3. 实现功能
