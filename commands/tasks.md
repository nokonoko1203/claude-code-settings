---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit
description: Break down design into implementable tasks (Stage 3 of Spec-Driven Development)
---

## Context

- Requirements: @.tmp/requirements.md
- Design document: @.tmp/design.md
- Task breakdown template: @~/.claude/CLAUDE.md#stage-3-task-listタスク分解

## Your task

### 1. Verify prerequisites

- Check that both `.tmp/requirements.md` and `.tmp/design.md` exist
- If not, inform user to complete previous stages first

### 2. Analyze design document

Read and understand the design thoroughly to identify all implementation tasks

### 3. Create Task List Document

Create `.tmp/tasks.md` with the following structure:

```markdown
# タスクリスト - [プロジェクト名]

## 概要

- 総タスク数: [数]
- 推定作業時間: [時間/日数]
- 優先度: [高/中/低]

## タスク一覧

### Phase 1: 基盤セットアップ

#### Task 1.1: プロジェクト初期設定

- [ ] プロジェクト構造の作成
- [ ] 必要な依存関係のインストール
- [ ] 開発環境の設定ファイル作成
- **完了条件**: `npm install`が正常に動作する
- **依存**: なし
- **推定時間**: 30分

#### Task 1.2: 基本設定

- [ ] TypeScript設定
- [ ] Linter/Formatter設定
- [ ] テスト環境設定
- **完了条件**: lint, typecheck, testコマンドが動作する
- **依存**: Task 1.1
- **推定時間**: 1時間

### Phase 2: コア機能実装

#### Task 2.1: [コンポーネント名]の実装

- [ ] インターフェース定義
- [ ] 基本実装
- [ ] ユニットテスト作成
- [ ] ドキュメント作成
- **完了条件**: 全テストがパスする
- **依存**: Task 1.2
- **推定時間**: 2時間

[続く...]

### Phase 3: 統合とテスト

#### Task 3.1: 統合テスト

- [ ] 統合テストケース作成
- [ ] E2Eテスト実装
- [ ] パフォーマンステスト
- **完了条件**: 全ての統合テストがパスする
- **依存**: 全Phase 2タスク
- **推定時間**: 3時間

### Phase 4: ドキュメントと仕上げ

#### Task 4.1: ドキュメント整備

- [ ] APIドキュメント
- [ ] 使用方法ガイド
- [ ] 開発者向けドキュメント
- **完了条件**: 全ドキュメントが最新状態
- **依存**: Phase 3完了
- **推定時間**: 2時間

## 実装順序

1. Phase 1を完全に完了
2. Phase 2のタスクは並行実行可能なものは並行で
3. Phase 3は全コンポーネント完成後
4. Phase 4で品質保証

## リスクと対策

- [特定されたリスク]: [対策方法]

## 注意事項

- 各タスクはコミット単位で完結させる
- タスク完了時は必ずlint/typecheckを実行
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

think hard

