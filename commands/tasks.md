---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__list_memories, mcp__serena__search_for_pattern, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
description: Break down design into implementable tasks (Stage 3 of Spec-Driven Development)
---

## Context

- Requirements: @.tmp/requirements.md
- Design document: @.tmp/design.md

## Your task

### 1. Verify prerequisites

- Check that both `.tmp/requirements.md` and `.tmp/design.md` exist
- If not, inform user to complete previous stages first

### 2. Analyze design document

**IMPORTANT: When investigating existing files or code, you MUST use serena. Using serena reduces token consumption by 60-80% and efficiently retrieves necessary information through semantic search capabilities.**

**IMPORTANT: When researching OSS libraries or external dependencies, you MUST use context7 tools. First use `mcp__context7__resolve-library-id` to get the library ID, then use `mcp__context7__get-library-docs` to retrieve the latest documentation.**

Read and understand the design thoroughly to identify all implementation tasks

### 3. Create Task List Document

Create `.tmp/tasks.md` with the following structure:

```markdown
# タスクリスト - [機能/改善名]

## 概要

- 総タスク数: [数]
- 推定作業時間: [時間/日数]
- 優先度: [高/中/低]

## タスク一覧

### Phase 1: 準備・調査

#### Task 1.1: [タスク名]

- [ ] [具体的な作業項目1]
- [ ] [具体的な作業項目2]
- [ ] [具体的な作業項目3]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク または なし]
- **推定時間**: [時間]

#### Task 1.2: [タスク名]

- [ ] [具体的な作業項目1]
- [ ] [具体的な作業項目2]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク]
- **推定時間**: [時間]

### Phase 2: 実装

#### Task 2.1: [機能名]の実装

- [ ] [実装項目1]
- [ ] [実装項目2]
- [ ] [実装項目3]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク]
- **推定時間**: [時間]

#### Task 2.2: [機能名]の実装

- [ ] [実装項目1]
- [ ] [実装項目2]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク]
- **推定時間**: [時間]

### Phase 3: 検証・テスト

#### Task 3.1: [検証項目]

- [ ] [テスト項目1]
- [ ] [テスト項目2]
- [ ] [テスト項目3]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク]
- **推定時間**: [時間]

### Phase 4: 仕上げ

#### Task 4.1: [仕上げ項目]

- [ ] [仕上げ作業1]
- [ ] [仕上げ作業2]
- **完了条件**: [明確な完了条件]
- **依存**: [依存するタスク]
- **推定時間**: [時間]

## 実装順序

1. Phase 1から順次実行
2. 並行実行可能なタスクは並行で実行
3. 依存関係を考慮した実装順序

## リスクと対策

- [特定されたリスク]: [対策方法]

## 注意事項

- 各タスクはコミット単位で完結させる
- タスク完了時は必要に応じて品質チェックを実行
- 不明点は実装前に確認する
```

### 4. Register tasks in TodoWrite

Extract main tasks (Phase level or important tasks) and register them using TodoWrite tool with appropriate priorities

### 5. Create implementation guide

Add a section at the end of tasks.md:

```markdown
## 実装開始ガイド

1. このタスクリストに従って順次実装を進めてください
2. 各タスクの開始時にTodoWriteでin_progressに更新
3. 完了時はcompletedに更新
4. 問題発生時は速やかに報告してください
```

### 6. Present to user

Show the task breakdown and:

- Explain the implementation order
- Highlight any critical paths
- Ask for approval to begin implementation

## Important Notes

- Tasks should be commit-sized (completable in 1-4 hours)
- Include clear completion criteria for each task
- Consider parallel execution opportunities
- Include testing tasks throughout, not just at the end

think super hard
