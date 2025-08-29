---
allowed-tools: mcp__obsidian-mcp-tools__get_active_file, mcp__obsidian-mcp-tools__update_active_file, mcp__obsidian-mcp-tools__patch_active_file, mcp__obsidian-mcp-tools__create_vault_file, mcp__obsidian-mcp-tools__get_vault_file, mcp__obsidian-mcp-tools__search_vault_simple, Read, Write
description: Natural language Obsidian assistant for fleeting notes and task management
---

## Quick Usage

```bash
/obs add <any content>                    # Add fleeting note
/obs task <natural language instruction>  # Manage tasks naturally
```

## Examples

### Adding Fleeting Notes
```bash
/obs add 今日の会議で新しいAPIアーキテクチャについて議論した
/obs add Research findings: MapLibre GL JS performs better than Leaflet
/obs add ChatGPTのAPI料金について調査した結果をまとめる
```

### Managing Tasks with Natural Language
```bash
# Adding tasks
/obs task PR確認を今日やるタスクに追加
/obs task turidocoのステージング環境構築を週内のタスクに追加して
/obs task PLATEAU全体会議の資料作成を忘れないようにメモ

# Completing tasks
/obs task PR確認を完了にして
/obs task アンケートのチェック終わった
/obs task 社内キックオフの設定done

# Listing tasks
/obs task 今日やるべきタスクを見せて
/obs task 週内のタスク一覧
/obs task 全部のタスクを表示

# Deleting tasks
/obs task 古いミーティングのタスクを削除
/obs task JAXAに連絡を消して
```

## Command Implementation

### Natural Language Processing Patterns

**Priority Detection:**
- "今日" / "今日中" / "本日" → 優先度高（今日）
- "週内" / "今週" / "今週中" → 優先度中（週内）
- "忘れないように" / "メモ" / "後で" → 優先度低（忘れないように）

**Action Detection:**
- Add: "追加" / "add" / "入れて" / "登録"
- Complete: "完了" / "終了" / "done" / "finished" / "終わった" / "済み"
- Delete: "削除" / "delete" / "remove" / "消して" / "消去"
- List: "一覧" / "list" / "表示" / "見せて" / "教えて"

**Task Pattern Matching:**
- Extract task content by removing action words and priority indicators
- Use fuzzy matching for task completion/deletion
- Support partial matches for better flexibility

### Implementation Flow

#### For `/obs add`:
1. Generate timestamp-based filename
2. Create fleeting note with frontmatter
3. Save to `Zettelekasten/FleetingNote/`
4. Append link to daily note's "## 仕事" section:
   - Find the "## 仕事" section
   - Locate the end of this section (before next section or end of file)
   - Insert new link at the bottom of the section
   - Ensures chronological order (newer entries below older ones)

#### For `/obs task`:
1. Parse natural language input
2. Detect action type (add/complete/delete/list)
3. Extract priority level if applicable
4. Extract task content/pattern
5. Execute appropriate operation:
   - **Add**: Insert task in correct priority section
   - **Complete**: Find matching tasks and mark with [x]
   - **Delete**: Remove matching task lines
   - **List**: Display tasks filtered by priority

### Smart Features

**Flexible Task Matching:**
- Partial string matching
- Ignore case sensitivity
- Support for project prefixes (e.g., "turidoco:")

**Context Awareness:**
- Detect current date for daily note
- Preserve existing structure and formatting
- Handle nested tasks appropriately
- Append new content to the END of "## 仕事" section (newer entries appear below older ones)

**Natural Response:**
- Provide conversational feedback in Japanese
- Confirm actions taken
- Show relevant task counts or summaries

### Error Handling

- If no daily note is active, suggest opening today's note
- If task pattern matches multiple items, show all matches
- If no matches found, provide helpful suggestions

**Important:** The system prioritizes natural interaction over strict syntax. Users can express their intent in various ways, and the command will interpret and execute appropriately.
