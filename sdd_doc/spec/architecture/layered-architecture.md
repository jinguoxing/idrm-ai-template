# 分层架构

> **Version**: 3.0.0  
> **Last Updated**: 2025-12-31

---

## 架构概览

```
HTTP Request → Handler → Logic → Model → Database
```

| 层级 | 目录 | 职责 | 最大行数 |
|------|------|------|----------|
| Handler | `api/internal/handler/` | 解析参数、格式化响应 | 30 |
| Logic | `api/internal/logic/` | 业务逻辑实现 | 50 |
| Model | `model/` | 数据访问 | 50 |

---

## 目录结构

### Handler 层

```
api/internal/handler/
├── {module}/                         # 模块目录
│   ├── create_category_handler.go    # go_zero 风格（下划线）
│   ├── get_category_handler.go
│   ├── list_category_handler.go
│   └── routes.go                     # goctl 生成
└── routes.go                         # 主路由
```

### Logic 层

```
api/internal/logic/
└── {module}/
    ├── create_category_logic.go      # go_zero 风格（下划线）
    ├── get_category_logic.go
    └── list_category_logic.go
```

### Types 层（按模块组织）

```
api/internal/types/
├── types.go                          # goctl 生成的基础类型
├── catalog/                          # 模块目录
│   ├── category_types.go
│   └── directory_types.go
└── auth/
    └── user_types.go
```

### Model 层

```
model/{module}/{table}/
├── interface.go                      # Model 接口
├── types.go                          # 数据结构
├── vars.go                           # 常量和错误
├── factory.go                        # ORM 工厂
├── gorm_dao.go                       # GORM 实现
└── sqlx_model.go                     # SQLx 实现
```

详见：[双ORM模式](./dual-orm-pattern.md)

---

## goctl 生成命令

```bash
# 使用 go_zero 风格生成（下划线分隔）
goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
```

详见：[API服务指南](./api-service-guide.md)

---

## 层级职责

### Handler 层

| ✅ 应该做 | ❌ 不应该做 |
|----------|------------|
| 解析 HTTP 请求 | 实现业务逻辑 |
| 参数验证（类型、必填） | 直接访问数据库 |
| 调用 Logic 层 | 直接调用 Model 层 |
| 格式化响应 | 复杂数据处理 |

### Logic 层

| ✅ 应该做 | ❌ 不应该做 |
|----------|------------|
| 实现业务规则 | 直接访问数据库 |
| 业务级数据验证 | 包含 HTTP 相关代码 |
| 调用 Model 层 | 操作 Request/Response |
| 数据格式转换 | 硬编码配置 |

### Model 层

| ✅ 应该做 | ❌ 不应该做 |
|----------|------------|
| 定义数据访问接口 | 实现业务逻辑 |
| 实现 CRUD 操作 | 了解上层业务概念 |
| 事务管理 | 包含非持久化代码 |

---

## 层间依赖规则

```
Handler → Logic → Model → Database
   ↓        ↓        ↓
   禁止反向依赖！
```

| 规则 | 说明 |
|------|------|
| ✅ 上层依赖下层 | Handler 可调用 Logic |
| ❌ 下层禁止依赖上层 | Model 不可调用 Logic |
| ✅ 通过接口解耦 | ServiceContext 使用接口类型 |

### ServiceContext 示例

```go
type ServiceContext struct {
    CategoryModel category.Model  // ✅ 接口类型
    // CategoryDao *gorm.CategoryDao  // ❌ 具体类型
}
```

---

## 数据转换边界

```
Handler → Logic: types.XxxReq
Logic → Model:   model.Entity
Model → Logic:   model.Entity
Logic → Handler: types.XxxResp
```

---

## 参考

- [API服务指南](./api-service-guide.md) - goctl 代码生成规范
- [双ORM模式](./dual-orm-pattern.md) - Model 层实现

---

**Version**: 3.0.0
