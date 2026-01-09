---
name: quality-check
description: Quality checks to run after every code change. Automatically triggered after code modifications to verify code quality and comment standards.
user-invocable: true
---

Based on the implementation requirements, verify the code from the following perspectives:

## Code Quality
1. Do not keep code that is planned for removal or otherwise unused (e.g., left behind “for backward compatibility”). If you find leftovers, delete them.
2. Do not leave unused variables, parameters, functions, classes, commented-out code, or unreachable branches.

## Comment Quality
1. Do not write progress/completion declarations such as “implemented” or “done” in comments or README files.
2. Do not include dates or relative time references (e.g., when it was implemented, which version introduced it, etc.).
