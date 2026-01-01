# Tasks Prompt

请根据技术设计文档拆分开发任务。

## 参考文档
- @.specify/memory/constitution.md
- @sdd_doc/spec/workflow/phase3-tasks.md

## 要求
1. 每个任务代码行数 < 50 行
2. 明确依赖关系（Model → Logic → Handler）
3. 包含详细验收标准
4. 按开发顺序排列
5. 每个任务可独立验证

## 任务拆分原则
- Model Layer: 接口定义、类型定义、GORM DAO
- Logic Layer: 业务逻辑实现
- Handler Layer: HTTP 处理
- Tests: 单元测试、集成测试

## 输出格式
使用 `.specify/templates/tasks-template.md` 模板格式

