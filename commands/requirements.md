---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*), mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__list_memories, mcp__serena__search_for_pattern, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
description: Create requirements specification for the given task (Stage 1 of Spec-Driven Development)
---

## Context

- Task description: $ARGUMENTS

## Your task

### 1. Create directory

- Create `.tmp` directory if it doesn't exist

### 2. Analyze the user's request

**IMPORTANT: When investigating existing files or code, you MUST use serena. Using serena reduces token consumption by 60-80% and efficiently retrieves necessary information through semantic search capabilities.**

**IMPORTANT: When researching OSS libraries or external dependencies, you MUST use context7 tools. First use `mcp__context7__resolve-library-id` to get the library ID, then use `mcp__context7__get-library-docs` to retrieve the latest documentation.**

Carefully analyze the provided task description and extract:

- The core problem to be solved
- Implicit requirements not explicitly stated
- Potential edge cases and constraints
- Success criteria

### 3. Create Requirements Document

Create `.tmp/requirements.md` with the following sections:

```markdown
# 要件定義書 - [タスク名]

## 1. 目的

[このタスク/プロジェクトの目的を明確に記述]

## 2. 機能要件

### 2.1 必須機能

- [ ] [機能1の詳細説明]
- [ ] [機能2の詳細説明]
      ...

### 2.2 オプション機能

- [ ] [将来的に実装可能な機能]
      ...

## 3. 非機能要件

### 3.1 パフォーマンス

- [応答時間、処理速度などの要件]

### 3.2 セキュリティ

- [セキュリティに関する要件]

### 3.3 保守性

- [コードの保守性に関する要件]

### 3.4 互換性

- [既存システムとの互換性要件]

## 4. 制約事項

### 4.1 技術的制約

- [使用技術、ライブラリの制約]

### 4.2 ビジネス制約

- [納期、予算などの制約]

## 5. 成功基準

### 5.1 完了の定義

- [ ] [明確な完了条件1]
- [ ] [明確な完了条件2]
      ...

### 5.2 受け入れテスト

- [ユーザーが満足する条件]

## 6. 想定されるリスク

- [実装上のリスクと対策]

## 7. 今後の検討事項

- [設計フェーズで詳細化すべき事項]
```

### 4. Create TODO entry

Use TodoWrite to add "要件定義の完了とレビュー" as a task

### 5. Present to user

Show the created requirements document and ask for:

- Confirmation of understanding
- Any missing requirements
- Approval to proceed to design phase

## Important Notes

- Be thorough in identifying implicit requirements
- Consider both current needs and future extensibility
- Use clear, unambiguous language
- Include measurable success criteria

think super hard
