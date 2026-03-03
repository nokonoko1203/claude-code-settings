# Guidelines

This document defines the project's rules, objectives, and progress management methods. Please proceed with the project according to the following content.

## Top-Level Rules

- To understand how to use a library, **always use the Context7 MCP** to retrieve the latest information.
- When investigating the source code, please use **LSP** as much as possible to ensure accurate code navigation and analysis.
- For front-end implementation, please ensure to verify the functionality **using Playwright CLI** (`playwright-cli` via Bash) before considering the work complete.
- If you need to check console logs or network requests, use **`playwright-cli console`** and **`playwright-cli network`**.
- Do not write code until the user approves the plan. Follow the order: research → plan → approval → implement.
- Write research findings and plans as markdown files in `.tmp` — never report only verbally. These files serve as shared documents for the user to review and annotate.
- When the user adds annotations to a plan, address all of them and update the document. Do not start implementing until explicitly told to.
- When seeking a decision from the user, use **AskUserQuestion**.
- Respond critically and without pandering to my opinions, but don't be forceful in your criticism.
- Whenever a task arises, **always launch the task management system** and organize the details clearly.
- When launching an agent team, always form: **Lead + Reviewer** (Claude Code agents for design/review) and **Implementer + Tester** (Claude Code agents for implementation and testing).
