# Spec-Kit Implement

Start implementing code based on task list.

## References
- @.specify/memory/constitution.md
- @sdd_doc/spec/workflow/phase4-implement.md
- @sdd_doc/spec/architecture/layered-architecture.md
- @sdd_doc/spec/coding-standards/naming-conventions.md

## Implementation Requirements

### 1. Follow Task Order
- Follow the order in task list
- Mark task as complete after finishing
- Run tests before committing code

### 2. Code Standards
- Functions must not exceed 50 lines
- All public functions must have Chinese comments
- Use unified error handling (pkg/errorx)
- Use unified response format (pkg/response)

### 3. Testing Requirements
- Core logic test coverage > 80%
- Each Logic function must have unit tests
- Critical flows need integration tests

### 4. Commit Standards
- Use standard commit messages (feat/fix/docs/etc)
- One task per commit
- Commit messages in Chinese

## Development Workflow

1. Read task description and acceptance criteria
2. Implement code
3. Write tests
4. Run `make test`
5. Mark task as complete
6. Commit code

## Common Commands

```bash
# Generate API code
make api

# Generate RPC code  
make rpc

# Run tests
make test

# Run lint
make lint
```
