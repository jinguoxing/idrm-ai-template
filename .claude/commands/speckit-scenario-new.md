---
description: Guide through complete new feature workflow (5 phases)
---

# /speckit.scenario.new

引导用户完成新功能开发的完整5阶段工作流。

## 场景识别

此场景适用于：
- `specs/{feature}/` 目录不存在
- 开始全新功能开发

## 执行步骤

按照 `.specify/workflows/scenario-1-new.md` 执行。

### Phase 1: Constitution（首次需要）
如果 `.specify/memory/constitution.md` 不存在，先创建。

### Phase 2-5: Specify → Plan → Tasks → Implement
每个阶段完成后停止等待用户确认。

## 模板引用
- `.specify/templates/constitution-template.md`
- `.specify/templates/spec-template.md`
- `.specify/templates/plan-template.md`
- `.specify/templates/tasks-template.md`

## 质量标准
- EARS 表示法
- Go-Zero 规范
- 函数 < 50 行
- 中文注释
- 测试 > 80%
