# Implement Prompt

请根据任务列表开始实现代码。

## 参考文档
- @.specify/memory/constitution.md
- @sdd_doc/spec/workflow/phase4-implement.md
- @sdd_doc/spec/architecture/layered-architecture.md
- @sdd_doc/spec/coding-standards/naming-conventions.md

## 实现要求

### 1. 按任务顺序实现
- 遵循任务列表中的顺序
- 每完成一个任务后标记为完成
- 提交代码前运行测试

### 2. 代码规范
- 函数不超过 50 行
- 所有公共函数必须有中文注释
- 使用统一的错误处理（pkg/errorx）
- 使用统一的响应格式（pkg/response）

### 3. 测试要求
- 核心逻辑测试覆盖率 > 80%
- 每个 Logic 函数必须有单元测试
- 关键流程需要集成测试

### 4. 提交规范
- 使用规范的 commit message (feat/fix/docs/etc)
- 一个任务一个 commit
- Commit message 使用中文描述

## 开发流程

1. 阅读任务描述和验收标准
2. 实现代码
3. 编写测试
4. 运行 `make test`
5. 标记任务为完成
6. 提交代码

## 常用命令

```bash
# 生成 API 代码
make api

# 生成 RPC 代码  
make rpc

# 运行测试
make test

# 运行 lint
make lint
```
