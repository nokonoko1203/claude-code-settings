---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__list_memories, mcp__serena__search_for_pattern, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
description: Create comprehensive test specification based on design document (Stage 3 of Spec-Driven Development)
---

## Context

- Design document: @.tmp/design.md

## Your task

### 1. Verify prerequisites

- Check that `.tmp/design.md` exists
- If not, inform user to run `/design` first

### 2. Analyze design document

**IMPORTANT: When investigating existing files or code, you MUST use serena. Using serena reduces token consumption by 60-80% and efficiently retrieves necessary information through semantic search capabilities.**

**IMPORTANT: When researching OSS libraries or external dependencies, you MUST use context7 tools. First use `mcp__context7__resolve-library-id` to get the library ID, then use `mcp__context7__get-library-docs` to retrieve the latest documentation.**

Read and understand the design document thoroughly, focusing on:

- API endpoints and interfaces
- Component behaviors
- Data flows
- Error handling requirements

### 3. Create Test Design Document

Create `.tmp/test_design.md` with the following sections:

````markdown
# テスト設計書 - [タスク名]

## 1. テスト概要

### 1.1 テスト目的

- [このテストスイートの目的]

### 1.2 テスト範囲

- 対象: [テスト対象のコンポーネント・API]
- 対象外: [テスト対象外の項目]

### 1.3 テスト環境

- 環境: [テスト実行環境]
- 依存関係: [必要な外部サービス・モック]

## 2. テストケース設計

### 2.1 [Component/API A]のテストケース

#### 2.1.1 正常系テスト

| ID   | テストケース名 | 入力データ | 期待結果         | 優先度 |
| ---- | -------------- | ---------- | ---------------- | ------ |
| T001 | [ケース名]     | [入力]     | [期待される出力] | High   |

#### 2.1.2 異常系テスト

| ID   | テストケース名 | 入力データ   | 期待結果           | 優先度 |
| ---- | -------------- | ------------ | ------------------ | ------ |
| T101 | [エラーケース] | [不正な入力] | [エラーレスポンス] | High   |

#### 2.1.3 境界値テスト

| ID   | テストケース名 | 入力データ     | 期待結果         | 優先度 |
| ---- | -------------- | -------------- | ---------------- | ------ |
| T201 | [境界値ケース] | [境界値データ] | [期待される動作] | Medium |

### 2.2 統合テストシナリオ

#### シナリオ1: [シナリオ名]

1. 前提条件: [初期状態]
2. テスト手順:
   - Step 1: [操作]
   - Step 2: [操作]
   - Step 3: [操作]
3. 期待結果: [最終状態]

## 3. テストデータ設計

### 3.1 マスタデータ

```json
{
  "testData": {
    "valid": {
      /* 正常系データ */
    },
    "invalid": {
      /* 異常系データ */
    },
    "boundary": {
      /* 境界値データ */
    }
  }
}
```

### 3.2 モックデータ

- [外部サービスのモックレスポンス]

## 4. パフォーマンステスト

### 4.1 負荷テスト

- 同時接続数: [数値]
- リクエスト数/秒: [数値]
- 期待レスポンスタイム: [ミリ秒]

### 4.2 ストレステスト

- 最大負荷条件: [条件]
- 期待される挙動: [挙動]

## 5. セキュリティテスト

### 5.1 認証・認可テスト

- 未認証アクセステスト
- 権限不足テスト
- トークン有効期限テスト

### 5.2 入力検証テスト

- SQLインジェクション
- XSS
- パストラバーサル

## 6. テスト実行計画

### 6.1 実行順序

1. 単体テスト
2. 統合テスト
3. パフォーマンステスト
4. セキュリティテスト

### 6.2 合格基準

- カバレッジ: [%]
- 全テストケースの合格
- パフォーマンス基準の達成

## 7. リスクと対策

| リスク    | 影響度 | 発生確率 | 対策   |
| --------- | ------ | -------- | ------ |
| [リスク1] | High   | Medium   | [対策] |

## 8. テスト自動化戦略

### 8.1 自動化対象

- [自動化するテストケース]

### 8.2 CI/CD統合

- [継続的テストの実行方法]
````

### 4. Update TODO

Use TodoWrite to add "テスト設計の完了とレビュー" as a task

### 5. Present to user

Show the created test design document and ask for:

- Test coverage feedback
- Test case approval
- Permission to proceed to task breakdown

## Important Notes

- Cover all critical paths from the design document
- Include edge cases and error scenarios
- Consider performance and security aspects
- Make test cases specific and measurable
- Ensure test data is realistic and comprehensive

think super hard
