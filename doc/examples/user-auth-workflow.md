# 用户认证功能 - 5 阶段完整示例

> **Version**: 1.0.0  
> **Last Updated**: 2025-12-31  
> **功能**: 用户注册与登录  
> **演示目的**: 展示 Spec-Driven 开发的完整流程

---

## 📋 示例概述

本示例演示如何使用 **5 阶段工作流** 开发一个用户注册和登录功能。

```
Phase 0: Context    → 理解项目规范
Phase 1: Specify    → 定义需求（spec.md）
Phase 2: Design     → 技术设计（plan.md）
Phase 3: Tasks      → 任务拆分（tasks.md）
Phase 4: Implement  → 实施验证
```

---

## 🚀 开始开发

### 启动 Prompt

在 Cursor 或 Claude 中使用以下 Prompt 开始：

```
@CLAUDE.md @sdd_doc/spec/core/workflow.md

我需要开发一个用户认证功能，包括：
1. 用户注册（手机号 + 密码）
2. 用户登录（返回 JWT Token）
3. 密码加密存储

请严格按照 5 阶段工作流执行，从 Phase 0 开始。
每完成一个阶段，请停止并等待我的确认。
```

---

# Phase 0: Context（上下文准备）

## AI 执行内容

```
我将执行 Phase 0: Context，阅读项目规范...

已阅读以下规范文档：
- sdd_doc/spec/core/project-charter.md
- sdd_doc/spec/core/tech-stack.md
- sdd_doc/spec/architecture/layered-architecture.md
- sdd_doc/spec/coding-standards/go-style-guide.md

**项目上下文理解**：

| 项目 | 内容 |
|------|------|
| 框架 | Go-Zero v1.9+ |
| 数据库 | MySQL 8.0 |
| 架构 | 分层架构（Handler → Logic → Model） |
| ORM | Dual ORM（GORM/SQLx） |

**技术注意事项**：
- 密码需使用 bcrypt 加密
- 登录返回 JWT Token
- 遵循 RESTful API 规范

**开发环境状态**：
- [ ] Go 1.21+ ✅
- [ ] goctl 工具 ✅
- [ ] 数据库连接 ✅

✅ **Phase 0 完成**

是否继续执行 Phase 1: Specify？
```

## 用户确认

```
继续
```

---

# Phase 1: Specify（需求规范）

## 输出文件: `specs/features/user-auth/spec.md`

```markdown
# User Auth Specification

> **Branch**: `feature/user-auth`  
> **Spec Path**: `specs/features/user-auth/`  
> **Created**: 2025-12-31  
> **Status**: Draft

---

## Overview

实现用户注册和登录功能，支持手机号密码认证，返回 JWT Token。

---

## User Stories

### Story 1: 用户注册 (P1)

AS a 新用户
I WANT 使用手机号和密码注册账号
SO THAT 可以使用系统的各项功能

**独立测试**: 注册成功后，使用相同手机号密码可以登录

### Story 2: 用户登录 (P1)

AS a 已注册用户
I WANT 使用手机号和密码登录
SO THAT 获取访问令牌使用系统功能

**独立测试**: 登录成功返回有效的 JWT Token

---

## Acceptance Criteria (EARS)

### 注册流程

| ID | Scenario | Trigger | Expected Behavior |
|----|----------|---------|-------------------|
| AC-01 | 注册成功 | WHEN 用户提交有效的手机号和密码 | THE SYSTEM SHALL 创建用户并返回 201 和用户 ID |
| AC-02 | 手机号为空 | WHEN 手机号参数为空 | THE SYSTEM SHALL 返回 400 和错误信息 "手机号不能为空" |
| AC-03 | 手机号格式错误 | WHEN 手机号不是 11 位数字 | THE SYSTEM SHALL 返回 400 和错误信息 "手机号格式不正确" |
| AC-04 | 密码为空 | WHEN 密码参数为空 | THE SYSTEM SHALL 返回 400 和错误信息 "密码不能为空" |
| AC-05 | 密码过短 | WHEN 密码少于 6 位 | THE SYSTEM SHALL 返回 400 和错误信息 "密码长度不能少于6位" |
| AC-06 | 手机号已注册 | WHEN 手机号已存在 | THE SYSTEM SHALL 返回 409 和错误信息 "手机号已注册" |

### 登录流程

| ID | Scenario | Trigger | Expected Behavior |
|----|----------|---------|-------------------|
| AC-10 | 登录成功 | WHEN 用户提交正确的手机号和密码 | THE SYSTEM SHALL 返回 200 和 JWT Token |
| AC-11 | 手机号不存在 | WHEN 手机号未注册 | THE SYSTEM SHALL 返回 401 和错误信息 "用户不存在" |
| AC-12 | 密码错误 | WHEN 密码不匹配 | THE SYSTEM SHALL 返回 401 和错误信息 "密码错误" |
| AC-13 | 参数为空 | WHEN 手机号或密码为空 | THE SYSTEM SHALL 返回 400 和相应错误信息 |

---

## Edge Cases

| ID | Case | Expected Behavior |
|----|------|-------------------|
| EC-01 | 并发注册同一手机号 | 仅一个成功，其他返回 409 |
| EC-02 | SQL 注入攻击 | 参数化查询，攻击无效 |
| EC-03 | Token 过期后登录 | 重新登录获取新 Token |
| EC-04 | 频繁登录失败 | （可选）实现账户锁定机制 |

---

## Business Rules

| ID | Rule | Description |
|----|------|-------------|
| BR-01 | 手机号唯一 | 系统中每个手机号只能注册一次 |
| BR-02 | 密码加密 | 密码必须使用 bcrypt 加密存储，禁止明文 |
| BR-03 | Token 有效期 | JWT Token 有效期为 24 小时 |
| BR-04 | 手机号格式 | 必须是 11 位数字，以 1 开头 |
| BR-05 | 密码强度 | 最少 6 位，建议包含字母和数字 |

---

## Data Considerations

| Field | Description | Constraints |
|-------|-------------|-------------|
| 用户 ID | 用户唯一标识 | 主键，自增 |
| 手机号 | 用户手机号 | 必填，11位数字，唯一 |
| 密码 | 加密后的密码 | 必填，bcrypt 加密 |
| 创建时间 | 注册时间 | 自动生成 |
| 更新时间 | 最后修改时间 | 自动更新 |

---

## Success Metrics

| ID | Metric | Target |
|----|--------|--------|
| SM-01 | 注册接口响应时间 | < 500ms (P99) |
| SM-02 | 登录接口响应时间 | < 300ms (P99) |
| SM-03 | 测试覆盖率 | > 80% |

---

## Open Questions

- [x] 是否需要邮箱注册？— 暂不需要，MVP 只支持手机号
- [x] 是否需要验证码？— 暂不需要，后期迭代添加
- [ ] 是否需要第三方登录？— 待确认

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-31 | AI | 初始版本 |
```

## AI 总结

```
✅ **Phase 1 完成**

已生成 specs/features/user-auth/spec.md，包含：
- 2 个 User Stories (注册、登录)
- 13 条验收标准 (EARS 格式)
- 4 个边界情况
- 5 条业务规则
- 5 个数据字段定义

请确认需求是否完整，是否继续 Phase 2: Design？
```

## 用户确认

```
需求确认，继续 Phase 2
```

---

# Phase 2: Design（技术设计）

## 输出文件: `specs/features/user-auth/plan.md`

```markdown
# User Auth Design

> **Branch**: `feature/user-auth`  
> **Input**: spec.md  
> **Created**: 2025-12-31

---

## Architecture

遵循分层架构：

```
HTTP Request
    ↓
Handler (参数解析、响应格式化) ≤30 行
    ↓
Logic (业务逻辑、密码加密、Token生成) ≤50 行
    ↓
Model (数据访问) ≤50 行
    ↓
Database (MySQL)
```

---

## File Structure

```
api/
├── doc/
│   └── user/
│       └── user.api              # [NEW] API 定义文件
├── internal/
│   ├── handler/user/
│   │   ├── register_handler.go   # [GENERATED] 注册 Handler
│   │   └── login_handler.go      # [GENERATED] 登录 Handler
│   ├── logic/user/
│   │   ├── register_logic.go     # [MODIFY] 注册业务逻辑
│   │   └── login_logic.go        # [MODIFY] 登录业务逻辑
│   └── types/
│       └── user/
│           └── types.go          # [GENERATED] 请求响应类型

model/
└── user/
    ├── interface.go              # [NEW] Model 接口
    ├── types.go                  # [NEW] 数据类型
    ├── vars.go                   # [NEW] 变量定义
    └── gorm_dao.go               # [NEW] GORM 实现

pkg/
└── jwt/
    └── jwt.go                    # [NEW] JWT 工具

migrations/
└── user/
    └── user.sql                  # [NEW] DDL 文件
```

---

## API Definition

### user.api

```api
syntax = "v1"

info (
    title:   "用户认证 API"
    desc:    "用户注册和登录"
    author:  "IDRM"
    version: "v1"
)

type (
    // 注册请求
    RegisterReq {
        Phone    string `json:"phone" validate:"required,len=11"`
        Password string `json:"password" validate:"required,min=6"`
    }
    
    // 注册响应
    RegisterResp {
        Id int64 `json:"id"`
    }
    
    // 登录请求
    LoginReq {
        Phone    string `json:"phone" validate:"required"`
        Password string `json:"password" validate:"required"`
    }
    
    // 登录响应
    LoginResp {
        Token    string `json:"token"`
        ExpireAt int64  `json:"expireAt"`
    }
)

@server (
    prefix: /api/v1/user
    group:  user
)
service api {
    @doc "用户注册"
    @handler RegisterHandler
    post /register (RegisterReq) returns (RegisterResp)
    
    @doc "用户登录"
    @handler LoginHandler
    post /login (LoginReq) returns (LoginResp)
}
```

---

## Interface Definitions

### Model Interface

```go
// model/user/interface.go
package user

import "context"

type UserModel interface {
    // Insert 创建用户
    Insert(ctx context.Context, data *User) error
    
    // FindByPhone 根据手机号查询用户
    FindByPhone(ctx context.Context, phone string) (*User, error)
    
    // FindOne 根据 ID 查询用户
    FindOne(ctx context.Context, id int64) (*User, error)
}
```

### Data Types

```go
// model/user/types.go
package user

import "time"

type User struct {
    Id        int64     `gorm:"primaryKey;autoIncrement"`
    Phone     string    `gorm:"type:varchar(11);uniqueIndex;not null"`
    Password  string    `gorm:"type:varchar(255);not null"`
    CreatedAt time.Time `gorm:"autoCreateTime"`
    UpdatedAt time.Time `gorm:"autoUpdateTime"`
}

func (User) TableName() string {
    return "users"
}
```

---

## Sequence Diagrams

### 注册流程

```
User        Handler         Logic           Model           DB
 |            |               |               |              |
 |--POST /register-->|        |               |              |
 |            |--Validate---->|               |              |
 |            |               |--FindByPhone->|              |
 |            |               |               |--SELECT----->|
 |            |               |<--nil---------|<-------------|
 |            |               |               |              |
 |            |               |--HashPassword |              |
 |            |               |               |              |
 |            |               |--Insert------>|              |
 |            |               |               |--INSERT----->|
 |            |               |<--userId------|<-------------|
 |            |<--201---------|               |              |
 |<--Response-|               |               |              |
```

### 登录流程

```
User        Handler         Logic           Model           DB
 |            |               |               |              |
 |--POST /login--->|          |               |              |
 |            |--Validate---->|               |              |
 |            |               |--FindByPhone->|              |
 |            |               |               |--SELECT----->|
 |            |               |<--user--------|<-------------|
 |            |               |               |              |
 |            |               |--ComparePassword             |
 |            |               |               |              |
 |            |               |--GenerateToken|              |
 |            |               |               |              |
 |            |<--200 + Token-|               |              |
 |<--Response-|               |               |              |
```

---

## Implementation Considerations

### 密码加密

```go
import "golang.org/x/crypto/bcrypt"

// 加密密码
hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)

// 验证密码
err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
```

### JWT 生成

```go
// pkg/jwt/jwt.go
func GenerateToken(userId int64, secret string, expireSeconds int64) (string, error) {
    claims := jwt.MapClaims{
        "userId": userId,
        "exp":    time.Now().Add(time.Duration(expireSeconds) * time.Second).Unix(),
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(secret))
}
```

### 错误码定义

```go
// pkg/errorx/codes.go
const (
    ErrUserNotFound     = 20001 // 用户不存在
    ErrPasswordWrong    = 20002 // 密码错误
    ErrPhoneRegistered  = 20003 // 手机号已注册
    ErrInvalidPhone     = 30001 // 手机号格式错误
    ErrPasswordTooShort = 30002 // 密码过短
)
```

---

## Dependencies

| 依赖 | 版本 | 用途 |
|------|------|------|
| golang.org/x/crypto | latest | bcrypt 密码加密 |
| github.com/golang-jwt/jwt/v5 | v5 | JWT Token 生成 |

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-31 | 初始设计 |
```

## AI 总结

```
✅ **Phase 2 完成**

已生成 specs/features/user-auth/plan.md，包含：
- 分层架构设计
- 12 个文件的变更清单（3 新建，2 修改，7 生成）
- API 定义（2 个接口）
- Model 接口定义
- 注册/登录序列图
- 实现注意事项（密码加密、JWT）

请确认设计是否满足需求，是否继续 Phase 3: Tasks？
```

## 用户确认

```
设计确认，继续 Phase 3
```

---

# Phase 3: Tasks（任务拆分）

## 输出文件: `specs/features/user-auth/tasks.md`

```markdown
# User Auth Tasks

> **Branch**: `feature/user-auth`  
> **Input**: spec.md, plan.md  
> **Created**: 2025-12-31

---

## Task Overview

| ID | Task | Story | Status | Parallel | Est. Lines |
|----|------|-------|--------|----------|------------|
| T001 | 创建 API 定义文件 | Setup | ⏸️ | - | 40 |
| T002 | 创建 DDL 文件 | Setup | ⏸️ | [P] | 15 |
| T003 | 运行 goctl 生成代码 | Setup | ⏸️ | - | - |
| T004 | 创建 JWT 工具包 | Setup | ⏸️ | [P] | 30 |
| T005 | 创建 Model 接口 | US1 | ⏸️ | - | 15 |
| T006 | 创建 Model 类型 | US1 | ⏸️ | [P] | 20 |
| T007 | 实现 GORM DAO | US1 | ⏸️ | - | 45 |
| T008 | 实现注册 Logic | US1 | ⏸️ | - | 40 |
| T009 | 实现登录 Logic | US2 | ⏸️ | [P] | 40 |
| T010 | 编写 Model 测试 | Test | ⏸️ | - | 50 |
| T011 | 编写 Logic 测试 | Test | ⏸️ | [P] | 50 |

---

## Phase 1: Setup

**目的**: 基础设施准备

### Step 1: 定义 API 和 DDL

- [ ] T001 创建 `api/doc/user/user.api`
  - 定义 RegisterReq/RegisterResp
  - 定义 LoginReq/LoginResp
  - 定义路由 /register 和 /login
  
- [ ] T002 [P] 创建 `migrations/user/user.sql`
  ```sql
  CREATE TABLE users (
      id BIGINT PRIMARY KEY AUTO_INCREMENT,
      phone VARCHAR(11) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  ```

### Step 2: 生成代码

- [ ] T003 运行 goctl 生成代码
  ```bash
  # 在 api/doc/api.api 中 import user.api
  goctl api go -api api/doc/api.api -dir api/ --style=go_zero
  ```

### Step 3: 创建工具包

- [ ] T004 [P] 创建 `pkg/jwt/jwt.go`
  - GenerateToken 函数
  - ParseToken 函数（可选）

**Checkpoint**: ✅ 基础设施就绪

---

## Phase 2: User Story 1 - 用户注册 (P1) 🎯 MVP

**目标**: 用户可以使用手机号和密码注册账号

**独立测试**: 注册成功后，数据库中存在该用户记录

### Step 1: Model 层

- [ ] T005 创建 `model/user/interface.go`
  ```go
  type UserModel interface {
      Insert(ctx context.Context, data *User) error
      FindByPhone(ctx context.Context, phone string) (*User, error)
  }
  ```

- [ ] T006 [P] 创建 `model/user/types.go`
  - User 结构体
  - TableName 方法

- [ ] T007 创建 `model/user/gorm_dao.go`
  - 实现 Insert 方法
  - 实现 FindByPhone 方法
  - 处理唯一约束错误

### Step 2: Logic 层

- [ ] T008 实现 `api/internal/logic/user/register_logic.go`
  - 检查手机号是否已注册
  - bcrypt 加密密码
  - 调用 Model.Insert
  - 返回用户 ID

**Checkpoint**: ✅ 用户注册功能可用

---

## Phase 3: User Story 2 - 用户登录 (P1)

**目标**: 已注册用户可以登录并获取 Token

**独立测试**: 登录成功返回有效的 JWT Token

### Step 1: Logic 层

- [ ] T009 [P] 实现 `api/internal/logic/user/login_logic.go`
  - 根据手机号查询用户
  - 验证密码
  - 生成 JWT Token
  - 返回 Token 和过期时间

**Checkpoint**: ✅ 用户登录功能可用

---

## Phase 4: Testing

**目的**: 确保代码质量

- [ ] T010 创建 `model/user/gorm_dao_test.go`
  - 测试 Insert 成功
  - 测试 Insert 手机号重复
  - 测试 FindByPhone 成功
  - 测试 FindByPhone 不存在

- [ ] T011 [P] 创建 `api/internal/logic/user/register_logic_test.go`
  - 测试注册成功
  - 测试手机号已存在
  - Mock Model 层

**Checkpoint**: ✅ 测试覆盖率 > 80%

---

## Phase 5: Polish

- [ ] T012 运行 `golangci-lint run`
- [ ] T013 补充注释（中文）
- [ ] T014 更新 ServiceContext（注入 UserModel）
- [ ] T015 运行完整测试 `go test -cover ./...`

---

## Dependencies

```
Phase 1 (Setup)
├── T001 (API) ──┐
│                ├──→ T003 (goctl)
├── T002 (DDL) ──┘
└── T004 (JWT) ─────→ T009 (Login Logic)

Phase 2 (US1: 注册)
├── T005 (Interface) ─→ T007 (GORM DAO)
├── T006 (Types) ──────┘
└── T008 (Register Logic) ←── T007

Phase 3 (US2: 登录)
└── T009 (Login Logic) ←── T004, T007

Phase 4 (Testing)
├── T010 (Model Test) ←── T007
└── T011 (Logic Test) ←── T008, T009

Phase 5 (Polish)
└── T012-T015 ←── All above
```

---

## Notes

- 每个 Task 完成后运行 `go build ./...` 确保编译通过
- T007 实现时注意处理 MySQL 唯一约束错误
- T008/T009 需要引入 bcrypt 依赖：`go get golang.org/x/crypto/bcrypt`
- T004 需要引入 JWT 依赖：`go get github.com/golang-jwt/jwt/v5`

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-31 | 初始任务拆分 |
```

## AI 总结

```
✅ **Phase 3 完成**

已生成 specs/features/user-auth/tasks.md，包含：
- 15 个任务（T001-T015）
- 5 个阶段（Setup → US1 → US2 → Testing → Polish）
- 4 个可并行任务标记 [P]
- 每个任务代码量 ≤50 行
- 明确的依赖关系图

请确认任务拆分是否合理，是否开始 Phase 4: Implement？
```

---

# Phase 4: Implement（实施验证）

## 执行 Prompt

```
开始 Phase 4: Implement

请按照 tasks.md 逐个执行任务。
从 T001 开始，每完成一个任务：
1. 展示代码
2. 更新任务状态
3. 运行编译检查
```

## 示例实现（T001: 创建 API 定义文件）

```api
// api/doc/user/user.api

syntax = "v1"

info (
    title:   "用户认证 API"
    desc:    "用户注册和登录"
    author:  "IDRM"
    version: "v1"
)

type (
    // 注册请求
    RegisterReq {
        Phone    string `json:"phone" validate:"required,len=11"`
        Password string `json:"password" validate:"required,min=6"`
    }
    
    // 注册响应
    RegisterResp {
        Id int64 `json:"id"`
    }
    
    // 登录请求
    LoginReq {
        Phone    string `json:"phone" validate:"required"`
        Password string `json:"password" validate:"required"`
    }
    
    // 登录响应
    LoginResp {
        Token    string `json:"token"`
        ExpireAt int64  `json:"expireAt"`
    }
)

@server (
    prefix: /api/v1/user
    group:  user
)
service api {
    @doc "用户注册"
    @handler RegisterHandler
    post /register (RegisterReq) returns (RegisterResp)
    
    @doc "用户登录"
    @handler LoginHandler
    post /login (LoginReq) returns (LoginResp)
}
```

## 验证命令

```bash
# 1. 运行 goctl 生成代码
goctl api go -api api/doc/api.api -dir api/ --style=go_zero

# 2. 编译检查
go build ./...

# 3. 运行测试
go test -cover ./...

# 4. Lint 检查
golangci-lint run
```

---

# 📝 完整 Prompt 参考

## 一键启动全流程

```
@CLAUDE.md @sdd_doc/spec/core/workflow.md

我需要开发一个用户认证功能：
- 用户注册（手机号 + 密码）
- 用户登录（返回 JWT Token）

请严格按照 5 阶段工作流执行。
1. 从 Phase 0 开始
2. 每个阶段完成后等待我确认
3. 输出物保存到 specs/features/user-auth/ 目录

开始执行 Phase 0。
```

## 阶段切换 Prompt

```
Phase [N] 确认，继续执行 Phase [N+1]。
```

## 任务执行 Prompt

```
继续 Phase 4，执行任务 T00X。
完成后展示代码并更新 tasks.md 状态。
```

---

## 📚 相关资源

| 资源 | 路径 |
|------|------|
| Spec 模板 | `.specify/templates/spec-template.md` |
| Plan 模板 | `.specify/templates/plan-template.md` |
| Tasks 模板 | `.specify/templates/tasks-template.md` |
| 工作流定义 | `sdd_doc/spec/core/workflow.md` |
| EARS 指南 | `sdd_doc/spec/workflow/ears-notation-guide.md` |

---

**Last Updated**: 2025-12-31
