---
name: self-review
description: Generate a self-review document before PR submission. Summarize the validity of modifications, existence of tests, and points of concern in Japanese.
allowed-tools: TodoWrite, TodoRead, Read, Write, Edit, Bash(git:*), Bash(mkdir:*), mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__find_referencing_symbols
user-invocable: true
---

## Self Review Skill

Generate a self-review document in Japanese before submitting a PR. This document summarizes the validity of changes, test coverage, and concerns.

### Usage

```
/self-review [base-branch]
```

- **No arguments**: Reviews the current branch, comparing against `main` as the base branch
- **With argument**: Compares the current branch against the specified base branch (e.g., `/self-review develop`)

The argument is available as `$ARGUMENTS`.

---

## Execution Process

**IMPORTANT: Use Serena MCP extensively to analyze code efficiently while minimizing token consumption.**

### 1. Get Branch Information

Execute the following commands to understand the changes:

```bash
# Get current branch name (this is the branch being reviewed)
git branch --show-current

# Determine base branch (use main if $ARGUMENTS is empty)

# Get list of changed files
git diff <base-branch>...HEAD --name-status

# Get commit history
git log <base-branch>..HEAD --oneline

# Get detailed diff
git diff <base-branch>...HEAD
```

### 2. Analyze Changes

For each changed file, perform the following analysis:

1. **Get symbol overview**: Use `mcp__serena__get_symbols_overview`
2. **Identify changed symbols**: Use `mcp__serena__find_symbol` for details
3. **Get original code**: Use `git show <base-branch>:path/to/file`
4. **Check related tests**: Review test file changes

### 3. Evaluate Validity

Evaluate each change from the following perspectives:

| Perspective    | What to Check                                               |
| -------------- | ----------------------------------------------------------- |
| Purpose        | What problem does it solve? Is the intent clear?            |
| Logic          | Is the implementation correct? Are edge cases handled?      |
| Error Handling | Is proper error handling implemented?                       |
| Compatibility  | Any breaking changes? Is backward compatibility maintained? |
| Performance    | Impact on performance (if applicable)                       |

### 4. Check Tests

- Presence of new test files
- Test coverage for each change
- Any gaps in test coverage

### 5. Generate Document

Output to `.tmp/code-review-<branch-name>.md` in Markdown format.

---

## Output Document Format

Generate the document with the following structure (in Japanese):

```markdown
# コードレビュー: <branch-name> ブランチ

## 概要

このブランチでは、以下の問題に対応しています：

1. **[問題1の名前]** - 問題の説明
2. **[問題2の名前]** - 問題の説明（該当する場合）

---

## 修正1: [修正の概要タイトル]

### 背景
この修正が必要になった背景や経緯を説明。どのような問題や要件があったのか。

### 実装の意図
この修正で達成しようとしていることの説明。なぜこのアプローチを選んだのか。

### 実装内容
具体的に何を実装したかの説明。変更の概要をわかりやすく記述。

### ファイル
`path/to/file.ts`

### 関数
`functionName(args): returnType`

### 修正前
```<lang>
// 修正前のコード
```

### 修正後
```<lang>
// 修正後のコード
```

### 修正の妥当性

| 観点               | 評価                        | 詳細 |
| ------------------ | --------------------------- | ---- |
| 目的               | OK / Needs Review / Problem | 説明 |
| ロジック           | OK / Needs Review / Problem | 説明 |
| エラーハンドリング | OK / Needs Review / Problem | 説明 |
| 互換性             | OK / Needs Review / Problem | 説明 |

### テストの有無

| テスト               | 状態     | ファイル   |
| -------------------- | -------- | ---------- |
| [テストケースの説明] | Yes / No | ファイル名 |

### 懸念事項

- **なし**: 特に懸念なし
- または具体的な懸念点を記載

---

## 修正2: [次の修正の概要]

（同様の構造で繰り返し）

---

## レビュー時の確認ポイント

### 高優先度

1. **[確認ポイント1]**
   - 確認すべき内容の詳細

### 中優先度

2. **[確認ポイント2]**
   - 確認すべき内容の詳細

### 低優先度

3. **[確認ポイント3]**
   - 確認すべき内容の詳細

---

## 変更ファイル一覧

| ファイル           | 変更内容       |
| ------------------ | -------------- |
| `path/to/file1.ts` | 変更内容の要約 |
| `path/to/file2.ts` | 変更内容の要約 |
```

---

## Guidelines

- **Write in Japanese**: All comments and descriptions in the output document must be in Japanese
- **Use tables**: Present validity evaluation and test status in table format for clarity
- **Include actual code**: Show real code snippets for before/after comparisons
- **Be honest about concerns**: Clearly indicate issues with appropriate labels
- **Prioritize review points**: Classify important items as "高優先度" (High Priority)
- **All changes as modifications**: Include new test files, test data, and any other changes as "修正N" sections

---

## Evaluation Criteria

Criteria for each perspective:

- **OK**: No issues, properly implemented
- **Needs Review**: Works correctly but needs confirmation or discussion
- **Problem**: Bug, security risk, or design problem

---

think super hard
