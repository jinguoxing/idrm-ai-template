# Spec-Kit Plan

Generate technical design documentation according to IDRM specifications.

## References
- @.specify/memory/constitution.md
- @sdd_doc/spec/architecture/layered-architecture.md
- @sdd_doc/spec/architecture/dual-orm-pattern.md
- @sdd_doc/spec/workflow/phase2-design.md

## Requirements
1. Follow layered architecture (Handler → Logic → Model)
2. Choose GORM or SQLx and explain rationale
3. List complete file structure
4. Define Model interface
5. Draw Mermaid sequence diagram
6. Include DDL and Go Struct definitions
7. Specify API Contract (go-zero .api format)

## Technical Constraints
- Functions MUST be < 50 lines
- MUST use Chinese comments
- Test coverage MUST be > 80%

## Output Format
Use `.specify/templates/design-template.md` template format
