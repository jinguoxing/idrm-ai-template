# 文档中心

> IDRM AI Template 项目文档

---

## 📚 文档索引

| 文档 | 说明 | 适用场景 |
|------|------|----------|
| [Claude Code + Spec 开发指导手册](./claude-code-guide.md) | AI 辅助开发的完整指南 | 使用 Claude/Cursor 进行开发 |

---

## � 示例教程

| 示例 | 说明 | 涉及阶段 |
|------|------|----------|
| [用户认证功能完整示例](./examples/user-auth-workflow.md) | 用户注册登录的 5 阶段完整演示 | Phase 0-4 全流程 |

---

## �🚀 快速开始

### 新手入门

1. 阅读 [Claude Code + Spec 开发指导手册](./claude-code-guide.md)
2. 了解 5 阶段工作流
3. 熟悉 Prompt 最佳实践

### 开发者

1. 查看 `sdd_doc/spec/` 目录下的规范文档
2. 使用 `.specify/templates/` 中的模板
3. 遵循 `CLAUDE.md` 中的项目指南

---

## 📁 相关资源

| 资源 | 路径 | 说明 |
|------|------|------|
| 项目规范 | `sdd_doc/spec/` | 架构、编码标准、工作流规范 |
| Spec 模板 | `.specify/templates/` | 需求、设计、任务模板 |
| Claude 指南 | `CLAUDE.md` | AI 工具的项目上下文 |
| Cursor 规则 | `.cursorrules` | Cursor 编辑器配置 |

---

## 📝 文档规范

### 新增文档

1. 文档使用 Markdown 格式
2. 文件名使用小写字母和连字符，如 `my-document.md`
3. 必须包含版本号和最后更新日期
4. 添加到本 README 的文档索引中

### 文档结构

```markdown
# 文档标题

> **Version**: x.x.x  
> **Last Updated**: YYYY-MM-DD

---

[正文内容]

---

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0.0 | YYYY-MM-DD | 初始版本 |
```

---

## 🔄 更新历史

| 日期 | 变更 |
|------|------|
| 2025-12-31 | 创建文档中心，添加 Claude Code 开发指导手册 |
