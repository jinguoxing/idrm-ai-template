# Phase 2: Design (技术方案)

> **Version**: 3.0.0  
> **Last Updated**: 2025-12-31

---

## 目标

基于 Phase 1 的业务需求，创建详细的技术实现方案。

## 输入

- Phase 1 的 `specs/{feature}/spec.md`

## 输出

创建 `specs/{feature}/plan.md`

模板参考：`.specify/templates/plan-template.md`

---

## Go-Zero 开发流程

按以下顺序设计和生成：

```
Step 1: 定义 API 文件 (.api)     → AI 实现
Step 2: 生成 Handler/Types       → goctl api go
Step 3: 定义 DDL 文件 (.sql)     → AI 实现
Step 4: 引用 Model 接口          → AI 实现
Step 5: 实现 Logic 层            → Phase 4 实施
```

---

## Step 1: API 文件定义

**AI 实现** | **位置**: `api/doc/{module}/{feature}.api`

```api
syntax = "v1"

import "../base.api"

type (
    CreateXxxReq {
        Name string `json:"name" validate:"required,max=50"`
    }
    CreateXxxResp {
        Id int64 `json:"id"`
    }
)

@server(
    prefix: /api/v1/{module}
    group: {feature}
)
service project-api {
    @handler CreateXxx
    post /{feature} (CreateXxxReq) returns (CreateXxxResp)
    
    @handler GetXxx
    get /{feature}/:id (IdReq) returns (XxxResp)
    
    @handler ListXxx
    get /{feature} (PageInfoWithKeyword) returns (ListXxxResp)
}
```

---

## Step 2: 生成 Handler/Types

**goctl 自动生成**

> ⚠️ **重要**：必须使用统一的 `api/doc/api.api` 入口文件执行 goctl，避免覆盖已有代码！

```bash
# 步骤1：在 api/doc/api.api 中 import 新模块的 API 文件
# 步骤2：执行 goctl（针对整个项目，不是单个功能）
goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
```

**生成文件**（可覆盖）：
- `api/internal/handler/{module}/*.go`
- `api/internal/types/types.go`

**不可覆盖**（已存在则跳过）：
- `api/api.go`
- `api/internal/svc/servicecontext.go`

---

## Step 3: DDL 文件定义

**AI 实现** | **位置**: `migrations/{module}/{table}.sql`

```sql
CREATE TABLE `{table}` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` varchar(50) NOT NULL COMMENT '名称',
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表注释';
```

---

## Step 4: Model 接口引用

**AI 实现** | **位置**: `model/{module}/{table}/`

Model 层采用双 ORM 模式，需手动定义接口：

```go
type Model interface {
    Insert(ctx context.Context, data *Entity) (*Entity, error)
    FindOne(ctx context.Context, id int64) (*Entity, error)
    Update(ctx context.Context, data *Entity) error
    Delete(ctx context.Context, id int64) error
    WithTx(tx interface{}) Model
}
```

详见：`sdd_doc/spec/architecture/dual-orm-pattern.md`

---

## 文件产出清单

| 序号 | 文件 | 生成方式 | 位置 |
|------|------|----------|------|
| 1 | 设计文档 | AI 实现 | `specs/{feature}/plan.md` |
| 2 | API 文件 | AI 实现 | `api/doc/{module}/{feature}.api` |
| 3 | DDL 文件 | AI 实现 | `migrations/{module}/{table}.sql` |
| 4 | Handler | goctl 生成 | `api/internal/handler/{module}/` |
| 5 | Types | goctl 生成 | `api/internal/types/` |
| 6 | Model | AI 实现 | `model/{module}/{table}/` |

---

## 质量门禁 (Gate 2)

- [ ] API 文件定义完整
- [ ] DDL 文件定义完整
- [ ] ORM 选择合理
- [ ] 符合分层架构
- [ ] 文件清单完整

---

## ⚠️ 人工检查点

> **AI MUST STOP HERE**

完成 Phase 2 后：
1. 向用户展示 `plan.md`、`.api`、`.sql` 文件
2. 等待用户审批后再继续 Phase 3
3. **禁止自动进入 Phase 3**

---

## 下一步

→ Phase 3: Tasks (需用户确认)
