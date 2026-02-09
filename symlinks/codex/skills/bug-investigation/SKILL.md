---
name: bug-investigation
description: Systematically investigate user-reported bugs and issues, generating detailed reports with root cause analysis, recommended fixes, symptom details, flow diagrams, error message mappings, code analysis, and prioritized fix proposals.
---

## Bug Investigation Skill

Systematically investigate user-reported bugs and issues, generating comprehensive analysis reports.

### Usage

```
/bug-investigation [symptom description or Issue number]
```

- **With arguments**: Start investigation based on the specified symptoms or Issue number
- **Without arguments**: Interactively gather symptom information from user

Arguments are available as `$ARGUMENTS`.

---

## Investigation Process

**IMPORTANT: Always use Serena MCP for code investigation. It reduces token consumption by 60-80% and efficiently retrieves information through semantic search.**

### Phase 1: Symptom Collection and Organization

1. **Gather symptom details**
   - Specific user experience (step-by-step)
   - Error messages (if any)
   - Reproduction conditions (device, OS, browser, steps)
   - Any temporary workarounds

2. **Classify symptoms**

   | Category | Examples |
   |----------|----------|
   | UI/UX Issues | Hidden buttons, layout problems |
   | Authentication Issues | Login failures, session expiry |
   | Functional Failures | Incomplete processing, errors |
   | Performance Issues | Slow loading, freezing |
   | Configuration Issues | External service integration problems |

### Phase 2: Related Code Investigation

1. **Check project structure**
   ```
   Use mcp__serena__list_dir to explore relevant directories
   Use mcp__serena__list_memories to check related memories
   ```

2. **Identify related files**
   - Routing/page files
   - Component files
   - API/service files
   - Configuration files

3. **Deep dive into code**
   ```
   Use mcp__serena__get_symbols_overview to understand file structure
   Use mcp__serena__find_symbol to investigate specific functions/classes
   Use mcp__serena__find_referencing_symbols to trace references
   ```

### Phase 3: Root Cause Analysis

1. **Visualize processing flow**
   - Use ASCII art to illustrate auth flows, data flows, screen transitions
   - Mark problem points with ★

2. **Review error handling**
   - Create error message to code mapping table
   - Check for unhandled cases

3. **Check environment dependencies**
   - iOS Safari specific issues (100vh, safe-area, etc.)
   - Browser compatibility
   - External service settings (Firebase, OAuth, etc.)

### Phase 4: Report Generation

Output to `.tmp/bug-investigation-<date>-<title>.md`

---

## Output Format

Generate a Markdown report with the following structure **in Japanese**:

```markdown
# バグ調査レポート: <タイトル>

作成日: YYYY-MM-DD

## 調査対象

1. [症状1の要約]
2. [症状2の要約]
（報告された症状の数だけ繰り返し）

---

## 1. [症状名]

### 症状の詳細

**ユーザーが経験する状況**:
1. [ステップ1]
2. [ステップ2]
3. [問題が発生]

**ユーザーが見る画面/メッセージ**:
- [具体的な表示内容]

**影響を受ける環境**:
- [デバイス/OS/ブラウザ]

### 処理フローの図解

```
[開始]
    ↓ 操作
[処理1]
    ↓ 条件分岐
    ├─ 正常系 → [成功]
    └─ ★異常系 → [問題発生]
```

### 原因分析

**関連ファイル**: `path/to/file.ext`

**問題のあるコード（XX-YY行目）**:
```typescript
// 問題のあるコード
```

**問題点**:

| 問題 | 説明 |
|-----|------|
| [問題1] | [説明] |
| [問題2] | [説明] |

**なぜこの問題が発生するのか**:
[技術的な説明]

### エラーメッセージと原因の対応表

| 表示されるメッセージ | エラーコード | 原因 | 対処法 |
|-------------------|------------|------|--------|
| [メッセージ] | [コード] | [原因] | [対処] |

### 推奨修正

**修正方針**: [修正の概要]

```typescript
// 修正後のコード例
```

**修正の効果**:
- [効果1]
- [効果2]

---

## 2. [次の症状名]

（同様の構造で繰り返し）

---

## 優先度と対応推奨

| 問題 | 優先度 | 工数 | 修正種別 | 対応推奨 |
|-----|-------|------|---------|---------|
| [問題1] | 高/中/低 | 高/中/低 | コード修正/設定変更/調査継続 | [推奨内容] |

---

## 追加調査が必要な項目

### [問題名]について
- **必要な情報**: [収集すべき情報]
- **確認事項**: [確認すべき項目]

---

## 関連ファイル一覧

| ファイル | 役割 | 修正の必要性 |
|---------|------|-------------|
| `path/to/file1` | [役割] | あり/なし/要確認 |
```

---

## Investigation Guidelines

### Flow Diagrams

- **Processing flows**: Illustrate auth, data processing, screen transitions
- **Screen structure**: Show UI layout relationships using ASCII art (especially for layout issues)
- **Problem points**: Mark with ★ where issues occur

### Error Message Mapping

- Investigate error handling in code
- Organize mapping between user-visible messages and error codes
- Point out any unhandled cases

### Root Cause Deep Dive

| Aspect | What to Check |
|--------|---------------|
| Code Logic | Missing conditionals, unhandled edge cases |
| Async Processing | Timeouts, race conditions, missing await |
| Environment | iOS Safari, browser compatibility, viewport units |
| External Integration | Firebase, OAuth, API settings |
| CSS/Layout | safe-area, fixed elements, z-index |

### Priority Criteria

| Priority | Criteria |
|----------|----------|
| **High** | Users cannot use the service, security risks |
| **Medium** | Feature works but inconvenient, affects some users |
| **Low** | UX improvements, preventive measures |

### Effort Criteria

| Effort | Criteria |
|--------|----------|
| **Low** | Few lines of changes, config changes only |
| **Medium** | Multiple file changes, testing required |
| **High** | Design changes, large-scale refactoring |

---

## Important Notes

- **Write report in Japanese**: All output content must be in Japanese
- **Specific code references**: Include file paths and line numbers
- **Mark uncertainties**: Use phrases like "可能性がある" (possibly) or "要確認" (needs confirmation) when uncertain
- **Reproduction steps**: Organize reproduction steps whenever possible
- **Request screenshots**: Ask users for screenshots when needed

---

think super hard
