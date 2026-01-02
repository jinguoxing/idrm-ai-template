# 场景化使用方案

> **Version**: 1.0.0  
> **Created**: 2026-01-02

---

## 概述

IDRM 模板提供 **4 种开发场景**，覆盖 95% 的实际开发工作。根据你的工作类型选择合适的场景，获得精准的工作流指导。

---

## 快速决策

```
开始
  │
  ▼
┌─────────────────────────────┐
│  specs/{feature}/ 目录存在？  │
└─────────────────────────────┘
         │
    ┌────┴────┐
    │         │
   否        是
    │         │
    ▼         ▼
┌───────┐  ┌─────────────────────────┐
│       │  │     变更规模多大？       │
│ 场景一 │  └─────────────────────────┘
│       │           │
│ 新功能 │     ┌─────┼─────┬──────┐
└───────┘    小    中    大    重构
              │     │     │      │
              ▼     ▼     ▼      ▼
          ┌─────┐┌─────┐┌─────┐┌─────┐
          │场景二││场景三││场景三││场景四│
          │小改动││ 扩展 ││ 扩展 ││ 重构 │
          └─────┘└─────┘└─────┘└─────┘
```

---

## 4 种场景

| 场景 | 适用条件 | 文档存在 | 变更规模 |
|------|----------|----------|----------|
| **场景一：新功能** | 全新功能开发 | ❌ 不存在 | 完整5阶段 |
| **场景二：小改动** | Bug修复、参数调整 | ✅ 存在 | < 50 行 |
| **场景三：扩展** | 添加子功能、新接口 | ✅ 存在 | 中等 |
| **场景四：重构** | 架构变更、接口调整 | ✅ 存在 | 大规模 |

---

## 场景一：新功能 🆕

**适用于**：全新项目的首个功能，或现有项目中的全新功能模块。

**工作流**：
```
Constitution → Specify → Plan → Tasks → Implement
```

**触发命令**：
- Cursor: `/speckit-scenario-new`
- Claude Code: `/speckit.scenario.new`

**详细指南**：[scenario-1-new.md](../../.specify/workflows/scenario-1-new.md)

---

## 场景二：小改动 🔧

**适用于**：Bug 修复、参数调整、性能优化，代码量 < 50 行。

**工作流**：
```
识别改动点 → 更新 tasks.md → 执行实现
```

**触发命令**：
- Cursor: `/speckit-scenario-update`
- Claude Code: `/speckit.scenario.update`

**详细指南**：[scenario-2-update.md](../../.specify/workflows/scenario-2-update.md)

---

## 场景三：扩展 ➕

**适用于**：添加子功能、扩展 API 接口，保持向后兼容。

**工作流**：
```
分析扩展点 → 扩展 spec.md → 扩展 plan.md → 更新 tasks.md → 实现
```

**触发命令**：
- Cursor: `/speckit-scenario-extend`
- Claude Code: `/speckit.scenario.extend`

**详细指南**：[scenario-3-extend.md](../../.specify/workflows/scenario-3-extend.md)

---

## 场景四：重构 🔄

**适用于**：架构重构、接口签名变更、涉及破坏性变更。

**工作流**：
```
审查现有文档 → 创建 v2 目录 → 重新设计 → 迁移任务 → 执行迁移
```

**触发命令**：
- Cursor: `/speckit-scenario-refactor`
- Claude Code: `/speckit.scenario.refactor`

**详细指南**：[scenario-4-refactor.md](../../.specify/workflows/scenario-4-refactor.md)

---

## 工具命令速查

| 场景 | Cursor | Claude Code |
|------|--------|-------------|
| 新功能 | `/speckit-scenario-new` | `/speckit.scenario.new` |
| 小改动 | `/speckit-scenario-update` | `/speckit.scenario.update` |
| 扩展 | `/speckit-scenario-extend` | `/speckit.scenario.extend` |
| 重构 | `/speckit-scenario-refactor` | `/speckit.scenario.refactor` |

---

## 相关文档

- [效益分析](./benefits-analysis.md) - 实施场景化方案的价值
- [Cursor 使用指南](../cursor-speckit-guide.md)
- [Claude Code 使用指南](../claude-code-guide.md)
- [完整决策树](../../.specify/workflows/README.md)
