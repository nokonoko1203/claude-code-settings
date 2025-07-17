# Guidelines

This document defines the project's rules, objectives, and progress management methods. Please proceed with the project according to the following content.

## Top-Level Rules

- To maximize efficiency, **if you need to execute multiple independent processes, invoke those tools concurrently, not sequentially**.
- **You must think exclusively in English**. However, you are required to **respond in Japanese**.
- To understand how to use a library, **always use the Contex7 MCP** to retrieve the latest information.
- For temporary notes for design, create a markdown in `.tmp` and save it.
- **After using Write or Edit tools, ALWAYS verify the actual file contents using the Read tool**, regardless of what the system-reminder says. The system-reminder may incorrectly show "(no content)" even when the file has been successfully written.
- Please respond critically and without pandering to my opinions, but please don't be forceful in your criticism.

## Programming Rules

- Avoid hard-coding values unless absolutely necessary.
- Do not use `any` or `unknown` types in TypeScript.
- You must not use a TypeScript `class` unless it is absolutely necessary (e.g., extending the `Error` class for custom error handling that requires `instanceof` checks).

## Development Style - Specification-Driven Development

### Overview

When receiving development tasks, please follow the 4-stage workflow below. This ensures requirement clarification, structured design, and efficient implementation.

### 4-Stage Workflow

#### Stage 1: Requirements

- Analyze user requests and convert them into clear functional requirements
- Document the following items in `.tmp/requirements.md`:
  - **概要**: Summary of the requirements
  - **目的**: Project or task objectives
  - **機能要件**: Detailed list of features to implement
  - **非機能要件**: Performance, security, maintainability, etc.
  - **制約事項**: Technical constraints and prerequisites
  - **成功基準**: Definition of completion

#### Stage 2: Design

- Create technical design based on requirements
- Document the following items in `.tmp/design.md`:
  - **概要**: Summary of the requirements
  - **アーキテクチャ概要**: Overall system configuration
  - **コンポーネント設計**: Responsibilities and interactions of each module
  - **データフロー**: Data flow and transformation
  - **APIインターフェース**: Internal/external API specifications
  - **技術選定**: Libraries and frameworks to use

#### Stage 3: Task List

- Break down design into implementable units
- Document in `.tmp/tasks.md` with the following format:
  - Small tasks in commit units
  - Dependencies between tasks
  - Clear implementation order
  - Completion conditions for each task
- Manage major tasks with TodoWrite tool

#### Stage 4: Implementation

- Implement according to task list
- For each task:
  - Update task to in_progress using TodoWrite
  - Execute implementation and testing
  - Run lint and typecheck
  - Update task to completed using TodoWrite

### Workflow Commands

- `/spec` - Start the complete specification-driven development workflow
- `/requirements` - Execute Stage 1: Requirements only
- `/design` - Execute Stage 2: Design only (requires requirements)
- `/tasks` - Execute Stage 3: Task breakdown only (requires design)

### Important Notes

- Each stage depends on the deliverables of the previous stage
- Please obtain user confirmation before proceeding to the next stage
- Always use this workflow for complex tasks or new feature development
- Simple fixes or clear bug fixes can be implemented directly
