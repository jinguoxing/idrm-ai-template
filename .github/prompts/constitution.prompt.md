# Constitution Prompt

请为项目创建开发准则和原则（Constitution）。

## 参考文档
- @sdd_doc/spec/core/workflow.md
- @sdd_doc/spec/architecture/layered-architecture.md
- @sdd_doc/spec/coding-standards/naming-conventions.md

## 要求

定义以下方面的准则：

### 1. 代码质量标准
- 函数行数限制
- 测试覆盖率要求
- 注释规范（中文注释）

### 2. 架构原则
- 分层架构规范（Handler/Logic/Model）
- ORM 选型策略
- 错误处理策略

### 3. 开发流程
- 5 阶段工作流（Context → Specify → Design → Tasks → Implement）
- 文档要求
- Review 标准

### 4. Go-Zero 最佳实践
- API 定义规范（.api 文件）
- RPC 定义规范（.proto 文件）
- 配置文件规范

## 输出格式
使用 `.specify/memory/constitution.md` 格式
