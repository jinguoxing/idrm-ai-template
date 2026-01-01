# 模板使用指南

> 针对不同场景的用户提供详细的使用步骤

---

## 目录

1. [场景 A: 新项目（从零开始）](#场景-a新项目从零开始)
2. [场景 B: 现有项目（引入模板）](#场景-b现有项目引入模板)
3. [场景 C: 仅使用规范文档](#场景-c仅使用规范文档)
4. [常见问题](#常见问题)

---

## 场景 A：新项目（从零开始）

**适用情况**：你还没有代码仓库，想基于模板创建新项目。

### 方式 1: 使用 GitHub Template（推荐）

**优点**: 保留完整的 Git 历史，便于后续更新

```bash
# 1. 在 GitHub 上点击 "Use this template" → "Create a new repository"
#    - Repository name: my-project
#    - 选择 Public/Private
#    - 点击 "Create repository"

# 2. 克隆你的新仓库
git clone https://github.com/yourusername/my-project.git
cd my-project

# 3. 初始化项目（替换模块路径）
./scripts/init.sh github.com/yourusername/my-project

# 或者选择需要的服务类型
./scripts/init.sh github.com/yourusername/my-project --services api,rpc --yes

# 4. 提交初始化更改
git add -A
git commit -m "chore: 初始化项目"
git push origin main
```

### 方式 2: 直接克隆模板

**优点**: 简单快速

```bash
# 1. 克隆模板
git clone https://github.com/jinguoxing/idrm-ai-template.git my-project
cd my-project

# 2. 移除模板的 Git 历史，创建自己的仓库
rm -rf .git
git init
git branch -M main

# 3. 初始化项目
./scripts/init.sh github.com/yourusername/my-project

# 4. 创建远程仓库并推送
# 先在 GitHub 创建空仓库 my-project
git add -A
git commit -m "chore: 初始化项目"
git remote add origin https://github.com/yourusername/my-project.git
git push -u origin main
```

### 方式 3: 使用 goctl（Go-Zero 用户）

```bash
# 1. 使用 goctl 创建项目骨架
goctl api new my-project
cd my-project

# 2. 从模板复制需要的文件和目录
# 例如：.specify/, sdd_doc/, pkg/, deploy/ 等

# 3. 手动集成需要的功能
```

---

## 场景 B：现有项目（引入模板）

**适用情况**：你已经有一个运行中的项目，想引入 IDRM 模板的规范和工具。

### 方式 1: 选择性合并（推荐）

```bash
# 1. 在项目目录外克隆模板
cd /path/to/workspace
git clone https://github.com/jinguoxing/idrm-ai-template.git idrm-template

# 2. 进入你的现有项目
cd /path/to/your-project

# 3. 选择性复制需要的内容

# 复制 Spec-Kit 模板（规范驱动开发）
cp -r ../idrm-template/.specify .

# 复制规范文档
cp -r ../idrm-template/sdd_doc .
cp -r ../idrm-template/doc .

# 复制公共包（按需选择）
cp -r ../idrm-template/pkg .

# 复制部署配置（可选）
cp -r ../idrm-template/deploy .

# 复制 AI 配置
cp ../idrm-template/CLAUDE.md .
cp ../idrm-template/.cursorrules .

# 4. 手动调整
# - 更新 go.mod 中的模块路径（如果需要）
# - 调整 import 路径
# - 合并 Makefile

# 5. 提交更改
git add -A
git commit -m "feat: 引入 IDRM 规范和工具"
git push
```

### 方式 2: Git Subtree 合并

```bash
# 1. 添加模板作为远程仓库
cd /path/to/your-project
git remote add idrm-template https://github.com/jinguoxing/idrm-ai-template.git

# 2. 拉取模板内容
git fetch idrm-template

# 3. 合并特定目录
git subtree add --prefix=tools/idrm idrm-template main --squash

# 4. 从 tools/idrm 复制需要的文件到项目根目录
cp -r tools/idrm/.specify .
cp -r tools/idrm/sdd_doc .
# ... 其他需要的文件

# 5. 清理临时目录
rm -rf tools/idrm

# 6. 提交
git add -A
git commit -m "feat: 集成 IDRM 模板规范"
```

### 逐步引入策略

如果项目较大，建议分阶段引入：

**阶段 1: 引入规范文档（1-2天）**
```bash
# 只复制文档和配置
cp -r ../idrm-template/.specify .
cp -r ../idrm-template/sdd_doc .
cp ../idrm-template/CLAUDE.md .
```

**阶段 2: 采用公共包（1周）**
```bash
# 复制公共包并逐步替换现有实现
cp -r ../idrm-template/pkg .

# 逐个模块迁移：
# - pkg/response → 替换现有响应处理
# - pkg/errorx → 统一错误码
# - pkg/middleware → 替换中间件
```

**阶段 3: 应用部署配置（1-2周）**
```bash
# 复制部署配置
cp -r ../idrm-template/deploy .

# 调整配置文件
# - 修改镜像名称
# - 调整环境变量
# - 适配现有基础设施
```

---

## 场景 C：仅使用规范文档

**适用情况**：只想使用开发规范和 AI 辅助功能，不改变现有代码结构。

### 最小化集成

```bash
# 1. 只复制 AI 和规范相关文件
cd /path/to/your-project

# Spec-Kit 模板
mkdir -p .specify/memory .specify/templates
curl -o .specify/memory/constitution.md \
  https://raw.githubusercontent.com/jinguoxing/idrm-ai-template/main/.specify/memory/constitution.md

# AI 配置
curl -o CLAUDE.md \
  https://raw.githubusercontent.com/jinguoxing/idrm-ai-template/main/CLAUDE.md
curl -o .cursorrules \
  https://raw.githubusercontent.com/jinguoxing/idrm-ai-template/main/.cursorrules

# 2. 根据项目调整 CLAUDE.md 和 constitution.md

# 3. 开始使用 AI 辅助开发
# Cursor: /speckit.specify
# Claude: 请按照 .specify/templates/requirements-template.md 创建规范
```

---

## 使用场景对比

| 场景 | 代码改动 | 学习成本 | 收益 | 推荐指数 |
|------|----------|----------|------|----------|
| **A: 新项目** | 无（全新） | 中 | 完整模板能力 | ⭐⭐⭐⭐⭐ |
| **B: 现有项目完全迁移** | 大 | 高 | 标准化 + 完整功能 | ⭐⭐⭐ |
| **B: 现有项目选择性引入** | 中 | 中 | 渐进式改进 | ⭐⭐⭐⭐ |
| **C: 仅规范文档** | 小 | 低 | AI 辅助 + 规范 | ⭐⭐⭐⭐ |

---

## 后续步骤

### 对于新项目

```bash
# 1. 开发第一个功能
# 使用 Spec-Kit（Cursor 用户）
/speckit.specify 创建用户认证功能

# 或直接引用模板（Claude Code 用户）
请按照 .specify/templates/requirements-template.md 创建用户认证功能规范

# 2. 生成 API 代码
make api

# 3. 本地开发
cd deploy/docker && docker-compose up -d

# 4. 运行服务
go run api/api.go -f api/etc/api.yaml
```

### 对于现有项目

```bash
# 1. 学习规范文档
cat sdd_doc/spec/core/workflow.md

# 2. 尝试用 AI 辅助开发一个小功能
# 例如：添加一个新的 API 接口

# 3. 逐步采用公共包
# 例如：先替换响应处理逻辑

# 4. 持续改进
# 定期查看模板更新，选择性合并新功能
```

---

## 常见问题

### Q1: 模板会不会和我现有项目冲突？

**答**：不会。场景 B 和 C 都支持选择性引入，只复制需要的部分。

### Q2: 如果只想用 Spec-Kit，不用其他功能？

**答**：使用场景 C，只复制 `.specify/` 和 `CLAUDE.md`。

### Q3: 如何保持与模板同步更新？

**方式 1: 手动合并**
```bash
# 查看模板最新变更
git remote add upstream https://github.com/jinguoxing/idrm-ai-template.git
git fetch upstream
git log upstream/main

# 选择性合并
git cherry-pick <commit-hash>
```

**方式 2: 定期检查**
```bash
# 每月查看模板仓库的 Release Notes
# 选择需要的新功能手动集成
```

### Q4: init.sh 脚本做了什么？

**答**：
1. 替换 `go.mod` 中的模块路径
2. 替换所有 Go 文件中的 import 路径
3. 更新配置文件中的项目名称
4. 清理不需要的服务目录（通过 `--services` 参数）
5. 运行 `go mod tidy` 安装依赖

**可以跳过吗？** 可以，但需要手动完成上述步骤。

### Q5: 我的项目不是 Go-Zero，可以用这个模板吗？

**答**：部分可以。

**可以使用**：
- `.specify/` Spec-Kit 模板（规范驱动开发）
- `sdd_doc/` 规范文档（通用开发规范）
- `CLAUDE.md` / `.cursorrules`（AI 配置）

**不适用**：
- `api/`、`rpc/` 等 Go-Zero 特定代码
- `pkg/` 中依赖 Go-Zero 的包

---

## 推荐阅读

- [README.md](../README.md) - 完整功能介绍
- [Claude Code 使用指南](claude-code-guide.md) - AI 辅助开发
- [Cursor + Spec-Kit 指导](cursor-speckit-guide.md) - Cursor 用户指南
- [部署指南](deployment-guide.md) - Docker/K8S 部署

---

**有问题？** 提交 Issue：https://github.com/jinguoxing/idrm-ai-template/issues
