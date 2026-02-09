---
name: codex-consult
description: "Delegate to Codex MCP for implementation, testing, review, or design consultation. Triggers on: 'codexに聞いて', 'codexにレビュー', 'codex consult', 'codexに実装させて', 'codexでテスト', 'second opinion'"
---

# Codex Consultation & Delegation

Bridge context from Claude Code to Codex MCP. Claude Code handles design/planning/review; Codex handles implementation/fixes/tests.

## Roles

| Role | sandbox | approval-policy |
|------|---------|-----------------|
| `reviewer` | `read-only` | `on-request` |
| `architect` | `read-only` | `on-request` |
| `designer` | `read-only` | `on-request` |
| `debugger` | `read-only` | `on-request` |
| `implementer` | `workspace-write` | `on-failure` |
| `tester` | `workspace-write` | `on-failure` |
| `refactorer` | `workspace-write` | `on-failure` |

## Workflow

### 1. Gather context

Collect from conversation, tasks, and files:
- Project overview (tech stack, dependencies, directory)
- Task description and objective
- Relevant code (key excerpts only, with file paths and line numbers)
- Architecture (system structure, data flow)
- Constraints (performance, compatibility, business rules)
- Specific question or implementation spec

### 2. Write context file

Save to `.tmp/codex-context/{YYYY-MM-DD}-{topic}.md`:

```markdown
---
role: {role}
project: {name}
created: {date}
---
# {Topic}

## Project Overview
- Tech stack: ...
- Directory: /path/to/project

## Task / Objective
{What to accomplish. For write roles, include completion criteria.}

## Relevant Code
### path/to/file.ts (L10-L30)
```lang
// excerpt
```

## Architecture
{System structure, data flow if relevant}

## Constraints
- {constraint}

## Question / Implementation Spec
{For read-only roles: specific question.}
{For write roles: design decisions, target files, change details, interfaces to preserve, testing requirements, out-of-scope items.}
```

### 3. Call Codex MCP

Use `mcp__codex__codex` with:

- **`prompt`**: Inline the full context file content
- **`cwd`**: Project root directory
- **`sandbox`** / **`approval-policy`**: Per role table above
- **`developer-instructions`**: Per role below

#### developer-instructions by role

| Role | Instructions |
|------|-------------|
| `reviewer` | You are a senior code reviewer. Focus on security, performance, design patterns, error handling, maintainability. Be specific with file paths and line numbers. Respond in Japanese. |
| `architect` | You are a system architect. Evaluate scalability, separation of concerns, data flow, failure modes, technology choices. Explain trade-offs. Respond in Japanese. |
| `designer` | You are a UI/UX expert. Evaluate component hierarchy, user flow, accessibility (WCAG), responsive design, consistency. Respond in Japanese. |
| `debugger` | You are a debugging specialist. Trace execution paths, identify root causes, suggest minimal targeted fixes. Respond in Japanese. |
| `implementer` | You are an expert engineer. Implement changes per the spec precisely. Follow existing conventions. Stay within spec scope. Run tests if command provided. Report changes and issues. Respond in Japanese. |
| `tester` | You are a test engineer. Write comprehensive tests for specified scenarios. Follow existing test patterns and framework. Run tests and report results. Respond in Japanese. |
| `refactorer` | You are a refactoring specialist. Preserve all existing behavior. Run tests after each change. Report all modified files. Respond in Japanese. |

### 4. Process response

- Save response to `.tmp/codex-context/{YYYY-MM-DD}-{topic}-response.md`
- **Read-only roles**: Summarize findings to user or team
- **Write roles**: Re-read modified files with Read tool, review for quality and spec compliance. Use `mcp__codex__codex-reply` with `threadId` to request fixes if needed.

## Rules

- Never include secrets (API keys, passwords, PII) in context
- Keep code excerpts relevant (target: under 2000 lines)
- **Always review Codex-written code before accepting** — Claude Code side is the final gatekeeper
- Context files in `.tmp/codex-context/` are not git-tracked
