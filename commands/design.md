---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__list_memories, mcp__serena__search_for_pattern, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
description: Create detailed design specification based on requirements (Stage 2 of Spec-Driven Development)
---

## Context

- Requirements document: @.tmp/requirements.md

## Your task

### 1. Verify prerequisites

- Check that `.tmp/requirements.md` exists
- If not, inform user to run `/requirements` first

### 2. Analyze requirements

**IMPORTANT: When investigating existing files or code, you MUST use serena. Using serena reduces token consumption by 60-80% and efficiently retrieves necessary information through semantic search capabilities.**

**IMPORTANT: When researching OSS libraries or external dependencies, you MUST use context7 tools. First use `mcp__context7__resolve-library-id` to get the library ID, then use `mcp__context7__get-library-docs` to retrieve the latest documentation.**

Read and understand the requirements document thoroughly

### 3. Create Design Document

Create `.tmp/design.md` with the following sections:

````markdown
# 詳細設計書 - [タスク名]

## 1. アーキテクチャ概要

### 1.1 システム構成図

[ASCII図やMermaid図でシステム全体の構成を表現]

### 1.2 技術スタック

- 言語: [使用言語とバージョン]
- フレームワーク: [使用フレームワーク]
- ライブラリ: [主要ライブラリ一覧] ※context7で最新情報を確認
- ツール: [ビルドツール、テストツールなど]

## 2. コンポーネント設計

### 2.1 コンポーネント一覧

| コンポーネント名 | 責務         | 依存関係                 |
| ---------------- | ------------ | ------------------------ |
| [Component A]    | [責務の説明] | [依存するコンポーネント] |

### 2.2 各コンポーネントの詳細

#### [Component A]

- **目的**: [このコンポーネントの目的]
- **公開インターフェース**:
  ```typescript
  interface ComponentA {
    method1(param: Type): ReturnType;
  }
  ```
````

- **内部実装方針**: [実装のアプローチ]

## 3. データフロー

### 3.1 データフロー図

[データの流れを示す図]

### 3.2 データ変換

- 入力データ形式: [形式の説明]
- 処理過程: [変換ロジック]
- 出力データ形式: [形式の説明]

## 4. APIインターフェース

### 4.1 内部API

[モジュール間のインターフェース定義]

### 4.2 外部API

[外部システムとの連携インターフェース]

## 5. エラーハンドリング

### 5.1 エラー分類

- [エラータイプ1]: [対処方法]
- [エラータイプ2]: [対処方法]

### 5.2 エラー通知

[エラーの通知方法とログ戦略]

## 6. セキュリティ設計

### 6.1 認証・認可

[必要に応じて記載]

### 6.2 データ保護

[機密データの扱い方]

## 7. テスト設計

**詳細なテスト設計については、`/test-design`コマンドを実行してテスト設計書を作成してください。**

テスト設計書では以下の内容を定義します：

- 正常系・異常系・境界値テストケース
- テストデータ設計
- パフォーマンス・セキュリティテスト
- 自動化戦略

## 8. パフォーマンス最適化

### 8.1 想定される負荷

[パフォーマンス要件]

### 8.2 最適化方針

[最適化のアプローチ]

## 9. デプロイメント

### 9.1 デプロイ構成

[本番環境へのデプロイ方法]

### 9.2 設定管理

[環境変数、設定ファイルの管理]

## 10. 実装上の注意事項

- [注意点1]
- [注意点2]

```

### 4. Update TODO
Use TodoWrite to add "詳細設計の完了とレビュー" as a task

### 5. Present to user
Show the created design document and ask for:
- Technical feedback
- Architecture approval
- Permission to proceed to task breakdown

## Important Notes
- Design should be implementable and testable
- Consider maintainability and extensibility
- Include concrete interface definitions where possible
- Address all requirements from the requirements document
```

think super hard
