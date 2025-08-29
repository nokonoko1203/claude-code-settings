---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*), mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__serena__list_memories, mcp__serena__read_memory, mcp__serena__write_memory, mcp__serena__find_referencing_symbols, mcp__serena__get_symbols_overview
description: WebGIS-focused educational code analysis and tutorial system using Serena MCP for efficient code exploration
---

## Quick Reference

```bash
/learn <file_path or code_snippet> [mode]              # Basic usage
/learn src/MapViewer.tsx -u                           # Understand implementation
/learn "spatial query code" -i                        # Improve code quality  
/learn src/tileManager.js -c                          # Compare alternatives
```

## Simple Analysis Modes

| Mode | Description | What You Get | Best For |
| ---- | ----------- | ------------ | -------- |
| `-u` | **Understand** | Implementation explanation + WebGIS domain knowledge | New code understanding, learning |
| `-i` | **Improve** | Code review + Performance + Security analysis | Quality improvement, problem solving |
| `-c` | **Compare** | Alternative approaches + Library comparison + Maintainability | Technology selection, refactoring |

## Mode Modifiers (Optional)

| Modifier | Description | Usage |
| -------- | ----------- | ----- |
| `-q` | Quick mode (key points only) | `/learn component.tsx -u -q` |
| `-d` | Deep mode (comprehensive analysis) | `/learn architecture/ -c -d` |

## Usage Examples

### Understanding Code (New Code Learning)
```bash
/learn src/MapViewer.tsx -u          # Basic understanding
/learn geoUtils.js -u -q             # Key points only
/learn spatialEngine/ -u -d          # Detailed understanding
```

### Improving Code (Quality Enhancement)
```bash
/learn userInput.js -i               # Quality check
/learn api/geoData.js -i -d          # Detailed quality analysis
```

### Comparing Options (Technology Selection)
```bash
/learn tileLoader.js -c              # Alternative exploration
/learn architecture/ -c -d           # Detailed comparison analysis
```

## Analysis Focus by Mode

### Understand Mode (`-u`)
**Understanding implementation mechanisms and design philosophy**
- Code purpose and responsibility scope
- Design patterns and technology choice rationale
- WebGIS-specific processing and considerations
- Learning points and application methods

### Improve Mode (`-i`) 
**Code quality improvement and problem solving**
- Quality assessment (readability, maintainability, consistency)
- Security risk identification
- Performance bottleneck analysis
- Concrete improvement suggestions with code examples

### Compare Mode (`-c`)
**Alternative approaches and technology selection evaluation**
- Current approach evaluation
- Alternative library and method comparison
- Long-term maintainability perspective
- Selection criteria and recommendations

## Command Implementation

Execute efficient code analysis leveraging WebGIS expertise and Serena MCP capabilities.

### Analysis Workflow

1. **Code Discovery with Serena MCP**
   - Use `mcp__serena__find_file` to locate relevant files
   - Use `mcp__serena__find_symbol` to find specific functions/classes
   - Use `mcp__serena__search_for_pattern` for code pattern analysis
   - Use `mcp__serena__get_symbols_overview` for codebase structure understanding

2. **Analysis Mode Execution**
   - **`-u` (Understand)**: Explain implementation + WebGIS domain knowledge
   - **`-i` (Improve)**: Code review + Performance + Security analysis
   - **`-c` (Compare)**: Alternative approaches + Library comparison + Maintainability

3. **Context Enhancement**
   - Use `mcp__serena__find_referencing_symbols` to understand dependencies
   - Use Context7 MCP for library documentation when needed
   - Apply WebGIS domain expertise throughout analysis

4. **Knowledge Management**
   - Use `mcp__serena__read_memory` to recall previous analysis
   - Use `mcp__serena__write_memory` to store learning insights
   - Generate structured report in `.tmp/learn_analysis.md`

### Key Implementation Guidelines

**Token Efficiency with Serena:**
- Always use Serena MCP tools for code exploration instead of basic Read/Glob tools
- Leverage semantic search capabilities to reduce token consumption by 60-80%
- Use symbol-based analysis for precise code understanding

**WebGIS Expertise Application:**
- Focus on coordinate system handling and spatial data processing
- Analyze geospatial library usage patterns
- Evaluate OGC standard compliance and best practices

**Educational Value:**
- Explain the "why" behind implementation decisions
- Provide concrete, actionable improvement suggestions
- Connect analysis to real-world WebGIS production considerations

### Analysis Report Structure

```markdown
# WebGIS学習分析: [対象コード]

## 分析概要
- [Serenaで発見したコード構造]
- [WebGISコンテキストでの役割]

## [選択モード別分析]
### Understand (-u) / Improve (-i) / Compare (-c)
- [詳細分析内容]

## WebGIS専門視点
- [地理空間データ処理の重要ポイント]
- [業界標準・ベストプラクティスとの比較]

## 実践的改善提案
- [具体的で実装可能な改善策]
- [コード例とサンプル]

## 学習リソース
- [関連ドキュメント・参考資料]
- [さらなる学習のための方向性]
```

**Important:** Always use Serena MCP tools for efficient code analysis and semantic understanding. This reduces token consumption significantly while providing deeper insights into code structure and relationships.