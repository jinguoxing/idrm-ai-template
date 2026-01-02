# Spec-Kit Scenario: New Feature

引导用户完成新功能开发的完整5阶段工作流。

---

## 场景识别

此场景适用于：
- `specs/{feature}/` 目录不存在
- 开始全新功能开发
- 需要完整的 Specify → Plan → Tasks → Implement 流程

---

## 工作流

按照 `@.specify/workflows/scenario-1-new.md` 中的定义执行。

### Phase 1: Constitution（首次需要）

如果 `.specify/memory/constitution.md` 不存在，先创建项目原则：

1. 阅读模板 `@.specify/templates/constitution-template.md`
2. 生成 `.specify/memory/constitution.md`

### Phase 2: Specify（需求规范）

1. 询问用户功能名称和需求描述
2. 读取模板 `@.specify/templates/spec-template.md`
3. 参考 `@.specify/memory/constitution.md`
4. 生成 `specs/{feature}/spec.md`
5. **⚠️ 停止并等待用户确认**

### Phase 3: Plan（技术设计）

1. 读取 `specs/{feature}/spec.md`
2. 读取模板 `@.specify/templates/plan-template.md`
3. 生成 `specs/{feature}/plan.md`
4. 生成 `api/doc/{module}/{feature}.api`
5. 生成 `migrations/{module}/{table}.sql`
6. **⚠️ 停止并等待用户确认**

### Phase 4: Tasks（任务拆分）

1. 读取 `specs/{feature}/plan.md`
2. 读取模板 `@.specify/templates/tasks-template.md`
3. 生成 `specs/{feature}/tasks.md`
4. **⚠️ 停止并等待用户确认**

### Phase 5: Implement（执行实现）

1. 读取 `specs/{feature}/tasks.md`
2. 执行 goctl 生成代码框架：
   ```bash
   goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
   ```
3. 按任务顺序实现代码
4. 编写测试

---

## 质量标准

生成的内容必须符合 IDRM 规范：

- ✅ 使用 EARS 表示法编写验收标准
- ✅ API 遵循 Go-Zero 语法
- ✅ 函数不超过 50 行
- ✅ 使用中文注释
- ✅ 测试覆盖率 > 80%

---

## 输出文件

```
specs/{feature}/
├── spec.md          # 需求规范
├── plan.md          # 技术设计
└── tasks.md         # 任务清单

api/doc/{module}/
└── {feature}.api    # API 定义

migrations/{module}/
└── {table}.sql      # DDL 定义
```

---

## Important

- 每个 Phase 完成后必须停止等待用户确认
- 占位符 `{{feature}}` 替换为实际功能名称
- 日期使用当前日期，格式：YYYY-MM-DD
- 遵循分层架构：Handler → Logic → Model
