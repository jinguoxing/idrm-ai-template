# 场景四：已有功能重构 - 大规模变更工作流

> **Version**: 1.0.0  
> **Created**: 2026-01-02  
> **Scenario**: Major Refactor / Migration

---

## 概述

本文档定义了**对已有功能进行大规模重构或迁移**的工作流。适用于：

- 架构重构
- 接口签名变更
- 数据库结构重大调整
- 功能合并或拆分
- 技术栈迁移

---

## 适用条件

使用此工作流的判断标准：

| 条件 | 状态 |
|------|------|
| `specs/{feature}/` 目录 | ✅ 存在 |
| 已有 spec.md | ✅ 存在 |
| 变更规模 | 🔄 大（重构） |
| 是否涉及破坏性变更 | ✅ 是 |
| 是否需要数据迁移 | 可能 |

---

## 工作流总览

```
Step 1: 审查现有文档
    ↓
Step 2: 创建 v2 版本目录
    ↓
Step 3: 重新设计 spec.md
    ↓ ⚠️ 人工检查点
Step 4: 重新设计 plan.md
    ↓ ⚠️ 人工检查点
Step 5: 创建迁移任务
    ↓ ⚠️ 人工检查点
Step 6: 执行迁移
```

---

## Step 1: 审查现有文档

### 目标

全面理解现有功能，识别需要变更的部分。

### 输入

- 重构需求
- 现有 `specs/{feature}/` 文档

### 活动

1. **阅读并标记现有文档**
   - ✅ 保留：仍然有效的内容
   - ⚠️ 修改：需要调整的内容
   - ❌ 删除：不再需要的内容
   - 🆕 新增：需要补充的内容

2. **创建审查报告**

```markdown
## 审查报告

### 保留的内容 ✅
- Story 1: 基础登录
- AC-1.1 ~ AC-1.3

### 需要修改的内容 ⚠️
- Story 2: 第三方登录 → 改为 OAuth 2.0 标准
- AC-2.1: 微信登录流程需要更新

### 需要删除的内容 ❌
- Story 3: 短信登录（已废弃）

### 需要新增的内容 🆕
- Story 4: SSO 单点登录
```

3. **评估迁移复杂度**
   - 影响范围
   - 数据迁移需求
   - 向后兼容策略
   - 回滚方案

### 输出

- 审查报告
- 迁移复杂度评估

---

## Step 2: 创建 v2 版本目录

### 目标

保留旧版本文档作为参考，创建新版本目录。

### 活动

```bash
# 创建版本化目录结构
specs/{feature}/
├── v1/                    # 旧版本（保留作为参考）
│   ├── spec.md
│   ├── plan.md
│   └── tasks.md
└── v2/                    # 新版本
    ├── spec.md
    ├── plan.md
    ├── tasks.md
    └── migration.md       # 迁移指南
```

```bash
# 执行命令
cd specs/{feature}
mkdir v1 v2
mv spec.md plan.md tasks.md v1/
```

### 输出

- 版本化的目录结构
- v1 目录包含原始文档

---

## Step 3: 重新设计 spec.md

### 目标

基于审查结果，创建新版本的需求规范。

### 输入

- Step 1 的审查报告
- `specs/{feature}/v1/spec.md`

### 活动

创建 `specs/{feature}/v2/spec.md`：

```markdown
# Feature: {Name} v2.0

> **Branch**: `feature/{feature-name}-v2`
> **Spec Version**: 2.0
> **Created**: 2026-01-02
> **Previous Version**: [v1](../v1/spec.md)

---

## 变更概述

### 从 v1 变更内容

| 类型 | 变更 |
|------|------|
| ✅ 保留 | Story 1: 基础登录 |
| ⚠️ 修改 | Story 2: 第三方登录 → OAuth 2.0 |
| ❌ 删除 | Story 3: 短信登录 |
| 🆕 新增 | Story 4: SSO 单点登录 |

### 破坏性变更

> ⚠️ **BREAKING CHANGES**

1. `/api/v1/login/wechat` → `/api/v2/oauth/wechat`
2. 响应结构变更：增加 `refresh_token` 字段
3. 数据库：`user.wechat_openid` 迁移到 `user_oauth` 表

---

## User Stories

### Story 1: 基础登录 (P1) ✅ 保留自 v1
...

### Story 2: OAuth 2.0 登录 (P1) ⚠️ 重构自 v1
AS a 用户
I WANT 使用 OAuth 2.0 标准登录
SO THAT 获得更安全的认证体验

### Story 4: SSO 单点登录 (P2) 🆕 新增
AS a 企业用户
I WANT 使用 SSO 单点登录
SO THAT 减少登录次数

---

## Acceptance Criteria
...
```

### 输出

- `specs/{feature}/v2/spec.md`

### 检查清单

- [ ] 变更概述清晰
- [ ] 破坏性变更列出
- [ ] 保留内容标记
- [ ] 新增内容完整

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

---

## Step 4: 重新设计 plan.md

### 目标

基于新需求，创建新版本的技术设计。

### 输入

- `specs/{feature}/v2/spec.md`
- `specs/{feature}/v1/plan.md`（参考）

### 活动

创建 `specs/{feature}/v2/plan.md`，重点包括：

1. **API 版本升级**
   ```api
   // v2 API 设计
   @server(
       prefix: /api/v2/oauth   // 版本号升级
       group: oauth
   )
   ```

2. **数据库迁移设计**
   ```sql
   -- 迁移脚本：从 user 表分离 oauth 数据
   CREATE TABLE `user_oauth` (
       `id` bigint NOT NULL AUTO_INCREMENT,
       `user_id` bigint NOT NULL,
       `provider` varchar(20) NOT NULL,
       `provider_id` varchar(64) NOT NULL,
       PRIMARY KEY (`id`),
       UNIQUE KEY `uk_provider` (`provider`, `provider_id`)
   );
   
   -- 数据迁移
   INSERT INTO `user_oauth` (user_id, provider, provider_id)
   SELECT id, 'wechat', wechat_openid FROM user WHERE wechat_openid IS NOT NULL;
   ```

3. **向后兼容层**（如需要）
   ```go
   // 兼容旧接口，转发到新接口
   // Deprecated: 使用 /api/v2/oauth/wechat
   func (h *Handler) LegacyWechatLogin(ctx context.Context, req *OldReq) (*OldResp, error) {
       // 转换请求，调用新接口
   }
   ```

### 输出

- `specs/{feature}/v2/plan.md`
- 新的 API 定义
- 数据库迁移脚本

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

---

## Step 5: 创建迁移任务

### 目标

创建详细的迁移任务清单和迁移指南。

### 输入

- `specs/{feature}/v2/plan.md`

### 活动

1. **创建 migration.md**

```markdown
# 迁移指南：{Feature} v1 → v2

## 迁移概述

| 项目 | v1 | v2 |
|------|----|----|
| API 前缀 | `/api/v1/login` | `/api/v2/oauth` |
| 数据存储 | `user` 表 | `user_oauth` 表 |
| 认证协议 | 自定义 | OAuth 2.0 |

## 迁移步骤

### Phase 1: 准备阶段
1. 备份数据库
2. 创建新表结构
3. 部署兼容层

### Phase 2: 数据迁移
1. 执行数据迁移脚本
2. 验证数据完整性
3. 灰度切换流量

### Phase 3: 清理阶段
1. 移除旧接口
2. 清理旧数据
3. 更新文档

## 回滚方案

如需回滚：
1. 恢复数据库备份
2. 切换流量到旧版本
3. 移除新代码
```

2. **创建 tasks.md**

```markdown
# Tasks: {Feature} v2.0

## 迁移任务组

### Task M1: 创建新表结构

**Status**: Not Started
**Type**: 🔄 Migration
**Estimated Lines**: 30

**Files**:
- `migrations/{module}/v2_create_oauth.sql`

---

### Task M2: 数据迁移脚本

**Status**: Not Started
**Depends on**: Task M1
**Type**: 🔄 Migration

...

### Task M3: 实现新 OAuth 接口

...

### Task M4: 兼容层实现

...

### Task M5: 旧接口标记废弃

...
```

### 输出

- `specs/{feature}/v2/migration.md`
- `specs/{feature}/v2/tasks.md`

### ⚠️ 人工检查点

> **AI MUST STOP HERE**

---

## Step 6: 执行迁移

### 目标

按照迁移计划执行变更。

### 活动

1. **准备阶段**
   - 备份数据库
   - 审查迁移脚本
   - 准备监控告警

2. **执行迁移**
   - 按任务顺序执行
   - 每步完成后验证
   - 记录执行日志

3. **验证阶段**
   - 功能测试
   - 性能测试
   - 兼容性测试

4. **清理阶段**
   - 移除兼容层（延后）
   - 清理旧数据（延后）
   - 更新文档

---

## 工具触发方式

| 工具 | 命令 | 说明 |
|------|------|------|
| **Cursor** | `/speckit-scenario-refactor` | 重构流程 |
| **Claude Code** | `/speckit.scenario.refactor` | 命令模式 |
| **手动** | 查阅本文档 | 无 AI 工具时 |

---

## 重构最佳实践

### 1. 渐进式迁移

- 先部署兼容层
- 灰度切换流量
- 逐步移除旧代码

### 2. 完善的回滚方案

- 数据库可回滚
- 代码可快速切换
- 监控及时告警

### 3. 充分的测试

- 单元测试覆盖
- 集成测试验证
- 压力测试确认

### 4. 文档同步

- 更新 API 文档
- 通知下游用户
- 记录变更历史

---

## 参考文档

- [场景选择决策树](./README.md)
- [场景一：新功能](./scenario-1-new.md)
- [场景二：小改动](./scenario-2-update.md)
- [场景三：功能扩展](./scenario-3-extend.md)
