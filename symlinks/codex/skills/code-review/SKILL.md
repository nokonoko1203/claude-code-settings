---
name: code-review
description: Comprehensive code review combining PR review, self-review, and quality checks. Supports reviewing PRs by number or comparing branches.
---

## Code Review Skill

Comprehensive code review skill that combines PR review, self-review, and quality checks.

### Usage

```
/code-review                # Self-review: current branch vs main
/code-review <branch>       # Self-review: current branch vs specified branch
/code-review pr <number>    # PR review: review the specified PR
```

The argument is available as `$ARGUMENTS`.

### Argument Parsing

```
$ARGUMENTS parsing:
- Empty → Self-review mode (base=main)
- "pr <number>" → PR review mode (use gh pr diff)
- Otherwise → Self-review mode (base=specified branch)
```

---

## Review Process

**IMPORTANT: Use Serena MCP extensively to analyze code efficiently while minimizing token consumption.**

**CRITICAL: Before starting any code review, you MUST read and understand the implementation guidelines:**
- Read `@~/.claude/templates/frontend-implementation-guidelines.md` for frontend code reviews
- Read `@~/.claude/templates/backend-implementation-guidelines.md` for backend code reviews
- Apply the specific principles from these guidelines during your review

### Step 1: Get Changes

**For Self-Review (no args or branch name):**
```bash
# Get current branch name
git branch --show-current

# Determine base branch (use main if $ARGUMENTS is empty, otherwise use $ARGUMENTS)
BASE_BRANCH=${ARGUMENTS:-main}

# Get list of changed files
git diff $BASE_BRANCH...HEAD --name-status

# Get commit history
git log $BASE_BRANCH..HEAD --oneline

# Get detailed diff
git diff $BASE_BRANCH...HEAD
```

**For PR Review (`pr <number>`):**
```bash
# Get PR information
gh pr view <number>

# Get PR diff
gh pr diff <number>
```

### Step 2: Quality Check (All Files)

Perform quality checks on all changed files before detailed review:

**Code Quality:**
1. Detect unused code (variables, parameters, functions, classes)
2. Detect commented-out code blocks
3. Detect unreachable code branches

**Comment Quality:**
1. Detect progress/completion declarations ("implemented", "done", etc.)
2. Detect date or version references in comments

**Detection Methods:**
- Use `mcp__serena__get_symbols_overview` to get symbol list
- Use `mcp__serena__find_referencing_symbols` to check reference count (0 = unused candidate)
- Use `Grep` for pattern matching:
  - `/\/\/.*?(実装済み|done|完了|implemented)/i`
  - `/\/\/.*?\d{4}[-\/]\d{1,2}[-\/]\d{1,2}/`
  - Consecutive commented-out lines (3+ lines)

### Step 3: Read Implementation Guidelines

Based on file extensions in the changes:
- `.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.svelte` → Read frontend guidelines
- `.py`, `.go`, `.java`, `.rs`, `.cs` → Read backend guidelines
- Both present → Read both guidelines

### Step 4: Analyze Each Change

For each changed file:
1. **Get symbol overview**: Use `mcp__serena__get_symbols_overview`
2. **Identify changed symbols**: Use `mcp__serena__find_symbol` for details
3. **Get original code**: Use `git show <base-branch>:path/to/file`
4. **Check impact**: Use `mcp__serena__find_referencing_symbols`
5. **Review related tests**: Check test file changes

### Step 5: Impact Analysis

Use `find_referencing_symbols` to investigate indirect impacts:
- Direct impact: List changed functions, APIs, screens
- Indirect impact: Identify callers/callees
- Breaking change risks: Type changes, return value changes, exception changes, state management changes, DB schema changes, cache changes

### Step 6: Generate Review Report

Save the review results to `.tmp/code-review-<branch-or-pr>.md`

---

## Output Format

Write the review in Japanese using the following format:

```markdown
# コードレビュー: <ブランチ名 または PR番号>

## 概要
[変更の目的と範囲の要約]

---

## Quality Check結果

### 未使用コードの検出
| ファイル | 行 | 種類 | 詳細 |
|----------|-----|------|------|
| path/to/file.ts | 42 | 未使用変数 | `unusedVar` |

### 不適切なコメントの検出
| ファイル | 行 | 内容 |
|----------|-----|------|
| path/to/file.ts | 15 | "実装済み" |

（問題なければ「問題なし」と記載）

---

## 修正1: [修正の概要タイトル]

### 背景・実装の意図
[修正が必要になった背景と、このアプローチを選んだ理由]

### ファイルと関数
- **ファイル**: `path/to/file.ts`
- **関数**: `functionName(args): returnType`

### 変更内容
```diff
- // 修正前
+ // 修正後
```

### 妥当性評価

| 観点 | 評価 | 詳細 |
|------|------|------|
| 目的 | OK / Needs Review / Problem | 説明 |
| ロジック | OK / Needs Review / Problem | 説明 |
| エラーハンドリング | OK / Needs Review / Problem | 説明 |
| 互換性 | OK / Needs Review / Problem | 説明 |
| パフォーマンス | OK / Needs Review / Problem | 説明 |

### テストの有無

| テストケース | 状態 | ファイル |
|-------------|------|----------|
| [テストの説明] | Yes / No | path/to/test.ts |

### 懸念事項
- [懸念点があれば記載、なければ「なし」]

---

（修正ごとに繰り返し）

---

## 波及範囲分析

### 直接影響
- [変更された関数、API、画面のリスト]

### 間接影響
- [find_referencing_symbolsで検出した呼び出し元/先]

### 破壊的変更の可能性
- [ ] 型変更
- [ ] 戻り値変更
- [ ] 例外変更
- [ ] 状態管理変更
- [ ] DBスキーマ変更
- [ ] キャッシュ変更

### 不確実性（推測箇所）
- [調査が完全でない部分、推測に基づく発見]

---

## 落とし穴チェックリスト

### セキュリティ
- [ ] 認可チェック
- [ ] 入力バリデーション
- [ ] ログ出力（機密情報漏洩なし）
- [ ] シークレット管理

### パフォーマンス
- [ ] N+1クエリ
- [ ] メモリ使用量
- [ ] 同期I/O
- [ ] キャッシュ戦略

### 例外処理
- [ ] リトライロジック
- [ ] 外部I/Oタイムアウト

### 互換性
- [ ] 公開API
- [ ] イベント
- [ ] データベーススキーマ

---

## 追加すべきテストケース

### 必須
1. [追加必須のテスト]

### 推奨
1. [あると良いテスト]

### エッジケース
1. [テストすべきエッジケース]

---

## 実装ガイドライン準拠性

### Frontend（該当する場合）
| 原則 | 準拠 | コメント |
|------|------|----------|
| 1. 関心の分離（カスタムフック） | ○/△/× | |
| 2. エラーハンドリング | ○/△/× | |
| 3. ローディング状態管理 | ○/△/× | |
| 4. メモ化によるパフォーマンス最適化 | ○/△/× | |
| 5. TypeScript型安全性 | ○/△/× | |
| 6. コンポーネント分解 | ○/△/× | |
| 7. 宣言的UIデザイン | ○/△/× | |
| 8. 集中データ管理 | ○/△/× | |
| 9. 定数の外部化 | ○/△/× | |
| 10. Props Drilling回避 | ○/△/× | |

### Backend（該当する場合）
| 原則 | 準拠 | コメント |
|------|------|----------|
| 1. レイヤードアーキテクチャ | ○/△/× | |
| 2. Result型エラーハンドリング | ○/△/× | |
| 3. 入力バリデーション | ○/△/× | |
| 4. 依存性注入 | ○/△/× | |
| 5. トランザクション管理 | ○/△/× | |
| 6. 認証・認可 | ○/△/× | |
| 7. 一貫したAPI設計 | ○/△/× | |
| 8. パフォーマンス最適化 | ○/△/× | |
| 9. セキュリティバイデザイン | ○/△/× | |
| 10. 可観測性 | ○/△/× | |
| 11. 信頼性パターン | ○/△/× | |
| 12. スケーラビリティ | ○/△/× | |

---

## レビューコメント

### 良い点
- [他の開発者が学べる優れた設計・実装のみ記載]

### 改善点・確認点
- [具体的な改善提案]

---

## 変更ファイル一覧

| ファイル | 変更種別 | 変更内容 |
|----------|----------|----------|
| path/to/file1.ts | Modified | 変更内容の要約 |
| path/to/file2.ts | Added | 変更内容の要約 |

---

## 結論

[全体的な評価と、マージ可否の判断材料]
```

---

## Review Guidelines

### Important Guidelines for Writing Comments

- **Inline Comment Structure:**
  - **Lead with conclusion:** Use a one-line summary of the main point
  - **Reasoning and suggestions:** After the conclusion, provide detailed explanation
  - **Focus on issues:** Focus on specific improvements like bug fixes, potential bugs, or readability issues

- **Regarding Positive Feedback:**
  - **Be selective:** Only mention exceptional design choices or innovative implementations
  - **Summarize positives:** Consolidate overall positive aspects in the summary section

### Review Perspectives

**[MANDATORY] Implementation Guidelines Compliance**

**For Frontend Code (`@~/.claude/templates/frontend-implementation-guidelines.md`):**
- **Principle 1**: Separation of Concerns Through Custom Hooks
- **Principle 2**: Comprehensive Error Handling with ErrorScreen components
- **Principle 3**: Loading State Management with LoadingScreen components
- **Principle 4**: Performance Optimization Through Memoization
- **Principle 5**: Type Safety with TypeScript
- **Principle 6**: Component Decomposition
- **Principle 7**: Declarative UI Design
- **Principle 8**: Centralized Data Management
- **Principle 9**: Externalization of Constants
- **Principle 10**: Avoiding Props Drilling

**For Backend Code (`@~/.claude/templates/backend-implementation-guidelines.md`):**
- **Principle 1**: Layered Architecture with Clear Boundaries
- **Principle 2**: Result-Based Error Handling and Logging
- **Principle 3**: Input Validation and Type Safety
- **Principle 4**: Dependency Injection for Testability
- **Principle 5**: Transaction Management
- **Principle 6**: Authentication and Authorization
- **Principle 7**: Consistent API Design
- **Principle 8**: Performance Optimization
- **Principle 9**: Security by Design
- **Principle 10**: Observable and Debuggable
- **Principle 11**: Reliability Engineering
- **Principle 12**: Scalability and Continuous Learning

### Evaluation Criteria

- **OK**: No issues, properly implemented
- **Needs Review**: Works correctly but needs confirmation or discussion
- **Problem**: Bug, security risk, or design problem

### Additional Notes

- Provide feedback in Japanese
- Give specific and actionable feedback
- Always explicitly state uncertainty - mark speculation clearly
- Use `mcp__serena__find_referencing_symbols` to assess breaking change risks

think super hard
