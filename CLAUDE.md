# Guidelines

This document defines the project's rules, objectives, and progress management methods. Please proceed with the project according to the following content.

## Top-Level Rules

- To understand how to use a library, **always use the Context7 MCP** to retrieve the latest information.
- When investigating the source code, please use **LSP** as much as possible to ensure accurate code navigation and analysis.
- For front-end implementation, please ensure to verify the functionality **using Playwright CLI** (`playwright-cli` via Bash) before considering the work complete.
- If you need to check console logs or network requests, use **`playwright-cli console`** and **`playwright-cli network`**.
- When seeking a decision from the user, please use appropriate questioning tools such as **AskUserQuestion**.
- For temporary notes for design, **create a markdown in `.tmp`** and save it.
- Please respond critically and without pandering to my opinions, but please don't be forceful in your criticism.
- Whenever a task arises, **always launch the task management system** and organize the details clearly.
- When launching an agent team, always form: **Lead + Reviewer** (Claude Code agents for design/review) and **Implementer + Tester** (Claude Code agents delegating to Codex CLI via `/codex` skill).
