---
description: Quick update for minor changes (< 50 lines)
---

# /speckit.scenario.update

引导用户对已有功能进行小规模修改。

## 场景识别

此场景适用于：
- `specs/{feature}/` 目录已存在
- 变更规模 < 50 行代码
- Bug 修复、参数调整、性能优化

## 执行步骤

按照 `.specify/workflows/scenario-2-update.md` 执行。

1. 识别改动点
2. 更新 tasks.md（添加修复任务）
3. 执行实现
4. 更新版本历史

## 快速路径

此场景通常可在 30 分钟内完成。

## 升级条件

- 需要新接口 → `/speckit.scenario.extend`
- 破坏性变更 → `/speckit.scenario.refactor`
