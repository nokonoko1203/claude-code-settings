---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*)
description: Start Specification-Driven Development workflow for the given task
---

## Context

- Task requirements: $ARGUMENTS

## Your task

Execute the complete Specification-Driven Development workflow:

### 1. Setup

- Create `.tmp` directory if it doesn't exist
- Create a new feature branch based on the task

### 2. Stage 1: Requirements

Execute `/requirements` command to create detailed requirements specification.

**Present requirements to user for approval before proceeding**

### 3. Stage 2: Design

Execute `/design` command to create technical design based on requirements.

**Present design to user for approval before proceeding**

### 4. Stage 3: Task List

Execute `/tasks` command to break down design into implementable tasks.

**Present task list to user for approval before proceeding**

### 5. Report completion

Summarize what was created and inform user that they can now proceed with implementation using the generated specification documents.

## Important Notes

- Each stage output should be detailed and actionable
- Wait for user confirmation between stages
- Focus on clarity and completeness in documentation
- Consider edge cases and error scenarios in each stage

think hard
