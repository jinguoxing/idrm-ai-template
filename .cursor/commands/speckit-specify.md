# Spec-Kit Specify

Generate requirements documentation according to IDRM specifications.

## References
- @.specify/memory/constitution.md
- @sdd_doc/spec/core/workflow.md
- @sdd_doc/spec/workflow/phase1-specify.md
- @sdd_doc/spec/workflow/ears-notation-guide.md

## Requirements
1. Use EARS notation (WHEN...THE SYSTEM SHALL...)
2. Write user stories in AS a / I WANT / SO THAT format
3. Do NOT include technical implementation details
4. Include Business Rules and Data Considerations
5. List Open Questions

## Output Format
Use `.specify/templates/requirements-template.md` template format

**Important**: 
- Replace `{{Feature Name}}` with the actual feature name
- Replace `[YYYY-MM-DD format, use current date when generating this document]` with today's date
- Replace `{{Author Name}}` with the appropriate author or leave as "AI Generated"
- Fill in all template sections completely

