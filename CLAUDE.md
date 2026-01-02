# CLAUDE.md

This file provides guidance to Claude (claude.ai/code, Cursor, Claude CLI) when working with code in the IDRM repository.

## Project Overview

**IDRM** (Intelligent Data Resource Management) is an intelligent data resource management platform built with Go-Zero microservices architecture.

| Item | Value |
|------|-------|
| Version | Spec v3.0 |
| Architecture | Go-Zero Microservices + Dual ORM |
| Development | AI-Assisted with Spec-Driven approach |

---

## 📖 Read Specifications First

Before any development work, read the specifications in `sdd_doc/spec/`:

| Category | Key Files |
|----------|-----------|
| Core | `core/project-charter.md`, `core/tech-stack.md`, `core/workflow.md` |
| Architecture | `architecture/layered-architecture.md`, `architecture/dual-orm-pattern.md` |
| Workflow | `workflow/phase1-specify.md`, `workflow/ears-notation-guide.md` |

---

## 🔄 Development Workflow (5-Phase)

**CRITICAL**: All development MUST follow the 5-phase workflow.

```
Phase 0: Context    → Understand specs and prepare environment
   ⚠️ STOP - Wait for user confirmation
Phase 1: Specify    → Define business requirements (EARS notation)
   ⚠️ STOP - Wait for user confirmation
Phase 2: Design     → Create technical solution
   ⚠️ STOP - Wait for user confirmation
Phase 3: Tasks      → Break down into <50 line tasks
   ⚠️ STOP - Wait for user confirmation
Phase 4: Implement  → Code, test, and verify
```

### ⚠️ Agent Behavior Rules

1. **ONE PHASE AT A TIME**: Execute only ONE phase per conversation turn
2. **WAIT FOR APPROVAL**: After completing a phase, STOP and ask for user confirmation
3. **NO AUTO-CONTINUE**: NEVER automatically proceed to the next phase

### Phase Output Summary

| Phase | Focus | Output | Template |
|-------|-------|--------|----------|
| 0: Context | Specs & environment | Understanding summary | - |
| 1: Specify | Business requirements | `specs/{feature}/spec.md` | `.specify/templates/spec-template.md` |
| 2: Design | Technical solution | `specs/{feature}/plan.md` | `.specify/templates/plan-template.md` |
| 3: Tasks | Work breakdown | `specs/{feature}/tasks.md` | `.specify/templates/tasks-template.md` |
| 4: Implement | Code & test | Working code with tests | - |

### EARS Notation (Phase 1)

```
WHEN [condition/event]
THE SYSTEM SHALL [expected behavior]
```

**Example**:
```markdown
WHEN 用户提交有效的分类创建请求
THE SYSTEM SHALL 保存分类并返回201状态码和分类ID
```

---

## 🏗️ Architecture

### Layered Architecture

```
HTTP Request → Handler → Logic → Model → Database
```

| Layer | Location | Responsibility | Max Lines |
|-------|----------|----------------|-----------|
| Handler | `api/internal/handler/` | Parse params, format response | 30 |
| Logic | `api/internal/logic/` | Business logic | 50 |
| Model | `model/` | Data access only | 50 |

### Dual ORM Pattern

| ORM | Use Case |
|-----|----------|
| **GORM** | Complex queries, joins, relationships, transactions |
| **SQLx** | Simple CRUD, high performance, direct SQL |

---

## 📁 Project Structure

```
idrm/
├── api/                          # API services
│   ├── doc/                      # API definitions (.api files)
│   ├── internal/
│   │   ├── handler/             # Handler layer
│   │   ├── logic/               # Logic layer
│   │   ├── svc/                 # Service context
│   │   └── types/               # Request/response types
│   └── etc/                     # Configuration
├── rpc/                          # RPC services
├── model/                        # Model layer (Dual ORM)
│   └── {module}/
│       ├── interface.go         # Model interface
│       ├── gorm_dao.go          # GORM implementation
│       └── sqlx_model.go        # SQLx implementation
├── common/                       # Shared utilities
└── sdd_doc/spec/                 # Specifications (READ FIRST!)
```

---

## 💻 Technology Stack

| Category | Technology |
|----------|------------|
| Language | Go 1.21+ |
| Framework | Go-Zero v1.9+ |
| Database | MySQL 8.0 |
| Cache | Redis 7.0 |
| MQ | Kafka 3.0 |
| Tools | goctl, golangci-lint |

---

## 📝 Coding Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | lowercase_underscore | `category_logic.go` |
| Packages | lowercase | `category` |
| Types | PascalCase | `CategoryModel` |
| Functions | camelCase/PascalCase | `createCategory`/`CreateCategory` |

### Code Rules

- **Comments**: All public functions MUST have Chinese comments
- **Error Handling**: Always wrap errors with `fmt.Errorf("context: %w", err)`
- **Custom Errors**: Use `errorx.NewCodeError(code, "message")`

### Error Code Ranges

| Range | Category |
|-------|----------|
| 10000-19999 | System errors |
| 20000-29999 | Business errors |
| 30000-39999 | Validation errors |
| 40000-49999 | Permission errors |

---

## 🧪 Testing & Quality

### Requirements

- **Coverage**: ≥80% for business logic
- **Pattern**: Table-driven tests preferred
- **Naming**: `{file}.go` → `{file}_test.go`

### Quality Gate Commands

```bash
go build ./...              # Build check
go test -cover ./...        # Test check (>80%)
golangci-lint run           # Lint check
```

---

## 🌐 API Standards

### RESTful Endpoints

```
GET    /api/v1/resources       # List
GET    /api/v1/resources/:id   # Get one
POST   /api/v1/resources       # Create
PUT    /api/v1/resources/:id   # Update
DELETE /api/v1/resources/:id   # Delete
```

### Response Format

```json
{
  "code": 0,
  "message": "success",
  "data": { ... }
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad request |
| 401 | Unauthorized |
| 404 | Not found |
| 500 | Server error |

---

## 🛠️ Common Commands

```bash
# Run services
cd api && go run xxx.go
cd rpc/resource_catalog && go run resource_catalog.go

# Code generation
goctl api go -api api/doc/api.api -dir api/ --style=go_zero --type-group
goctl rpc protoc rpc/xxx/xxx.proto --go_out=. --go-grpc_out=. --zrpc_out=.

# Testing
go test -cover ./...
go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out
```

---

## 🔀 Git Conventions

### Branch Naming

```
feature/category-management
fix/query-performance
docs/update-api-spec
refactor/model-layer
```

### Commit Messages

```
feat: 添加资源分类管理功能
fix: 修复分类查询bug
docs: 更新API文档
refactor: 重构model层
test: 添加单元测试
```

---

## ✅ DO / ❌ DON'T

### DO ✅
- Read specs before coding
- Follow 5-phase workflow
- Use EARS notation in Phase 1
- Separate Handler/Logic/Model layers
- Write tests (≥80% coverage)
- Handle errors with context

### DON'T ❌
- Skip Phase 1 (Specify)
- Put business logic in handlers
- Put data access in logic layer
- Ignore error returns
- Commit without tests
- Exceed function size limits

---

**Version**: Spec v3.0  
**Last Updated**: 2025-12-31
