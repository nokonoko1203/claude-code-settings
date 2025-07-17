---
allowed-tools: Bash(textlint:*), MultiEdit, Read, TodoWrite
description: Execute textlint on specified files, apply automatic fixes, manually fix remaining errors, and repeat until all errors are resolved
---

## Textlint Review

Execute textlint on the specified file, apply automatic and manual fixes, and repeat until all errors are resolved.

Usage: `/textlint <FILE_PATH>`
Example: `/textlint README.md`

The file path will be available as `$ARGUMENTS`.

Execution process:

1. **Initial lint execution**: Run `textlint -c ~/.claude/.textlintrc.json <FILE_PATH>` to detect issues
2. **Apply automatic fixes**: Run `textlint -c ~/.claude/.textlintrc.json --fix <FILE_PATH>` to fix auto-fixable issues
3. **Execute manual fixes**: Apply manual fixes for remaining issues:
   - Fix sentence-ending punctuation (change colons to periods)
   - Improve mechanical expressions (`**Item**: Description` → `**Item** (Description)`)
   - Clarify ambiguous expressions ("appropriate" → "specified", etc.)
   - Remove exclamation marks ("!" → ".")
   - Change bold attention prefixes to natural expressions
4. **Iterate**: Repeat until no errors remain or no improvement is observed

**Processing details:**

- Use TodoWrite to track progress
- Verify results at each step and apply fixes incrementally
- Confirm file content before and after fixes
- Monitor error count changes to prevent infinite loops

**Important notes:**

- Original files will be edited directly
- Large files may take time to process
- textlint must be installed and configured with config file at ~/.claude/.textlintrc.json

think hard
