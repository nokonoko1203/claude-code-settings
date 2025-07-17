---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(git:*, mkdir:*)
description: Start Specification-Driven Development workflow for the given task
---

## Context

- Task requirements: $ARGUMENTS
- Development workflow: @~/.claude/CLAUDE.md#development-style

## Your task

Execute the complete Specification-Driven Development workflow:

### 1. Setup

- Create `.tmp` directory if it doesn't exist
- Create a new feature branch based on the task

### 2. Stage 1: Requirements（要件定義）

Create `.tmp/requirements.md` with:

- **目的**: 明確なプロジェクトの目的
- **機能要件**: 実装すべき機能の詳細なリスト
- **非機能要件**: パフォーマンス、セキュリティ、保守性の要件
- **制約事項**: 技術的制約や前提条件
- **成功基準**: 完了の定義

**Present requirements to user for approval before proceeding**

### 3. Stage 2: Design（詳細設計）

Create `.tmp/design.md` with:

- **アーキテクチャ概要**: システム構成の全体像
- **コンポーネント設計**: 各モジュールの責務と相互作用
- **データフロー**: データの流れと変換
- **APIインターフェース**: 内部/外部APIの仕様
- **技術選定**: 使用するライブラリやフレームワーク
- **実装の考慮事項**: エラーハンドリング、ログ、テスト戦略

**Present design to user for approval before proceeding**

### 4. Stage 3: Task List（タスク分解）

Create `.tmp/tasks.md` with:

- コミット単位の実装タスク一覧
- 各タスクの依存関係の明示
- 実装順序の論理的な構成
- 各タスクの完了条件
- テストタスクの組み込み

Use TodoWrite to register main tasks

**Present task list to user for approval before proceeding**

### 5. Report completion

Summarize what was created and inform user that they can now proceed with implementation using the generated specification documents.

## Important Notes

- Each stage output should be detailed and actionable
- Wait for user confirmation between stages
- Focus on clarity and completeness in documentation
- Consider edge cases and error scenarios in each stage

think hard

