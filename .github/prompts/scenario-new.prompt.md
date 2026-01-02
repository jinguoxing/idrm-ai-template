# Scenario: New Feature Workflow

引导用户完成新功能开发的完整5阶段工作流。

---

## 场景识别

当满足以下条件时使用此工作流：
- 不存在 `specs/{feature}/` 目录
- 开始全新功能开发
- 需要完整的 Specify → Plan → Tasks → Implement 流程

---

## 工作流

按照 `.specify/workflows/scenario-1-new.md` 中的定义执行。

### Phase 1: Constitution（首次需要）

如果 `.specify/memory/constitution.md` 不存在，先创建：
- 使用模板: `.specify/templates/constitution-template.md`
- 输出: `.specify/memory/constitution.md`

### Phase 2: Specify（需求规范）

1. 读取模板: `.specify/templates/spec-template.md`
2. 参考: `.specify/memory/constitution.md`
3. 输出: `specs/{feature}/spec.md`
4. **⚠️ 停止并等待用户确认**

### Phase 3: Plan（技术设计）

1. 读取模板: `.specify/templates/plan-template.md`
2. 输出: `specs/{feature}/plan.md`
3. 输出: `api/doc/{module}/{feature}.api`
4. 输出: `migrations/{module}/{table}.sql`
5. **⚠️ 停止并等待用户确认**

### Phase 4: Tasks（任务拆分）

1. 读取模板: `.specify/templates/tasks-template.md`
2. 输出: `specs/{feature}/tasks.md`
3. **⚠️ 停止并等待用户确认**

### Phase 5: Implement（执行实现）

1. 执行 goctl: `goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group`
2. 按任务顺序实现代码
3. 编写测试

---

## 质量标准

- 使用 EARS 表示法编写验收标准
- API 遵循 Go-Zero 语法
- 函数不超过 50 行
- 使用中文注释
- 测试覆盖率 > 80%

---

## Important

- 每个 Phase 完成后必须停止等待用户确认
- 占位符替换为实际值
- 日期使用当前日期，格式：YYYY-MM-DD
