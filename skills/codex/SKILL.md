---
name: codex
description: "Delegate to Codex CLI for implementation, testing, review, or design consultation. Triggers: codex, ask codex, codex review, review this, second opinion"
---

# Codex CLI Delegation

Execute Codex CLI via `codex exec` to delegate implementation, review, testing, and consultation tasks.

## Command Format

```
codex exec --full-auto [--model <model>] --sandbox <sandbox_mode> --cd <project_directory> "<request>"
```

- Analysis/review roles (read-only): モデル指定なし（デフォルトモデルを使用）
- Implementation roles (workspace-write): `--model gpt-5.3-codex-spark` を指定

## Roles

| Role | sandbox | model | Use case |
|------|---------|-------|----------|
| `reviewer` | `read-only` | _(default)_ | Code review, security audit, quality check |
| `architect` | `read-only` | _(default)_ | Architecture analysis, design evaluation |
| `designer` | `read-only` | _(default)_ | UI/UX evaluation, accessibility audit |
| `debugger` | `read-only` | _(default)_ | Bug investigation, root cause analysis |
| `implementer` | `workspace-write` | `gpt-5.3-codex-spark` | Feature implementation, bug fixes |
| `tester` | `workspace-write` | `gpt-5.3-codex-spark` | Writing and running tests |
| `refactorer` | `workspace-write` | `gpt-5.3-codex-spark` | Refactoring, technical debt cleanup |

## Prompt Rules

**IMPORTANT**: Every request passed to Codex MUST include the following instruction:

> "No confirmation or questions needed. Provide concrete suggestions, fixes, and code examples proactively."

## Parameters

| Parameter | Description |
|-----------|-------------|
| `--full-auto` | Run in fully autonomous mode |
| `--model <model>` | Override model for this run (omit to use default) |
| `--sandbox read-only` | Read-only sandbox (safe for analysis/review) |
| `--sandbox workspace-write` | Write sandbox (for implementation/testing/refactoring) |
| `--cd <dir>` | Target project directory |
| `"<request>"` | The request content |

## Usage Examples

### Code Review (read-only)
```
codex exec --full-auto --sandbox read-only --cd /path/to/project "Review the code in this project and point out improvements. No confirmation or questions needed. Provide concrete fixes and code examples proactively."
```

### Bug Investigation (read-only)
```
codex exec --full-auto --sandbox read-only --cd /path/to/project "Investigate the cause of the authentication error. No confirmation or questions needed. Identify the root cause and provide concrete fix suggestions proactively."
```

### Implementation (workspace-write, spark)
```
codex exec --full-auto --model gpt-5.3-codex-spark --sandbox workspace-write --cd /path/to/project "Implement the user authentication feature according to the following spec: ... No confirmation or questions needed. Implement the changes and report all modified files proactively."
```

### Testing (workspace-write, spark)
```
codex exec --full-auto --model gpt-5.3-codex-spark --sandbox workspace-write --cd /path/to/project "Write comprehensive tests for the authentication module. Follow existing test patterns. No confirmation or questions needed. Write tests, run them, and report results proactively."
```

### Refactoring (workspace-write, spark)
```
codex exec --full-auto --model gpt-5.3-codex-spark --sandbox workspace-write --cd /path/to/project "Refactor the data access layer to use the repository pattern. Preserve all existing behavior. No confirmation or questions needed. Run tests after each change and report all modified files proactively."
```

### Architecture Analysis (read-only)
```
codex exec --full-auto --sandbox read-only --cd /path/to/project "Analyze and explain the architecture of this project. No confirmation or questions needed. Provide improvement suggestions proactively."
```

### Design Consultation (read-only)
```
codex exec --full-auto --sandbox read-only --cd /path/to/project "You are a world-class UI designer. Evaluate this project's UI from the following perspectives: (1) Visual hierarchy and typography, (2) Spacing and rhythm, (3) Color palette contrast and accessibility, (4) Interaction pattern consistency, (5) Reducing user cognitive load. No confirmation or questions needed. Provide concrete improvements with code examples proactively."
```

## Execution Steps

1. Receive the request from the user
2. Identify the target project directory (current working directory or user-specified)
3. Determine the appropriate role and sandbox mode based on the task
4. **Select the model**: write roles (implementer/tester/refactorer) use `--model gpt-5.3-codex-spark`, read-only roles omit `--model` (use default)
5. **When composing the prompt, ALWAYS append "No confirmation or questions needed. Provide concrete suggestions proactively." at the end**
6. Execute Codex using the command format above via the Bash tool
7. **For write roles (implementer/tester/refactorer)**: Re-read modified files with Read tool after execution, review for quality and spec compliance
8. Report the results to the user

## Rules

- Never include secrets (API keys, passwords, PII) in the prompt
- **Always review Codex-written code before accepting** — Claude Code side is the final gatekeeper
- Use `read-only` sandbox for analysis tasks, `workspace-write` for implementation tasks
