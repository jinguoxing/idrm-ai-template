# Spec-Kit Scenario: Feature Extension

引导用户在已有功能基础上进行扩展。

---

## 场景识别

此场景适用于：
- `specs/{feature}/` 目录已存在
- 需要添加新的 User Story
- 可能涉及新 API 接口或数据库字段
- 向后兼容，不涉及破坏性变更

---

## 工作流

按照 `@.specify/workflows/scenario-3-extend.md` 中的定义执行。

### Step 1: 分析扩展点

1. 询问用户扩展需求
2. 阅读现有文档：
   - `specs/{feature}/spec.md`
   - `specs/{feature}/plan.md`
3. 确定扩展位置
4. 评估向后兼容性

### Step 2: 扩展 spec.md

在现有 `specs/{feature}/spec.md` 中添加新内容（使用 🆕 标记）：

```markdown
### Story N: [新功能名称] (P2) 🆕 扩展
AS a [角色]
I WANT [功能]
SO THAT [价值]

### AC-N.1: [验收标准] 🆕 扩展
WHEN [条件]
THE SYSTEM SHALL [行为]
```

**⚠️ 停止并等待用户确认**

### Step 3: 扩展 plan.md

在现有 `specs/{feature}/plan.md` 中添加：

1. **新 API 接口**（如需要）
2. **新 DDL 字段**（如需要）
3. **更新文件清单**

```markdown
## 扩展文件清单 🆕

| 序号 | 文件 | 操作 | 说明 |
|------|------|------|------|
| 1 | `api/doc/{module}/{feature}.api` | 修改 | 添加新接口 |
| 2 | `migrations/{module}/xxx.sql` | 新增 | 新字段 |
```

**⚠️ 停止并等待用户确认**

### Step 4: 更新 tasks.md

添加扩展任务组：

```markdown
---

## 扩展任务组：[扩展名称] 🆕

### Task E1: [任务描述]
**Status**: Not Started
**Type**: ➕ Extension
...
```

**⚠️ 停止并等待用户确认**

### Step 5: 执行实现

1. 执行数据库变更（如有）
2. 重新生成代码框架：
   ```bash
   goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
   ```
3. 实现扩展功能
4. 编写测试

---

## 标记规范

- 🆕 新增内容
- ✅ 已实现
- ⚠️ 待修改

---

## 升级条件

如果发现以下情况，请升级到场景四：

- 需要修改现有接口签名
- 需要删除或合并已有功能
- 涉及破坏性变更

---

## Important

- 每个步骤完成后停止等待用户确认
- 使用 🆕 明确标记新增内容
- 确保向后兼容
- 更新版本历史
