---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*), Bash(gh pr view:*), Bash(gh pr diff:*), mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__list_memories, mcp__serena__search_for_pattern
description: Perform a thorough code review of pull requests following established guidelines, focusing on code quality, best practices, and maintainability while providing constructive feedback
---

## Code Review Rules

Review the pull request specified by the PR number provided in the command arguments.

Usage: `/code-review <PR_NUMBER>`
Example: `/code-review 001`

The PR number will be available as `$ARGUMENTS`.

Review process:

**IMPORTANT: When investigating existing files or code, you MUST use serena. Using serena reduces token consumption by 60-80% and efficiently retrieves necessary information through semantic search capabilities.**

**CRITICAL: Before starting any code review, you MUST read and understand the implementation guidelines:**
- Read `@~/.claude/templates/frontend-implementation-guidelines.md` for frontend code reviews
- Read `@~/.claude/templates/backend-implementation-guidelines.md` for backend code reviews
- Apply the specific principles from these guidelines during your review

1. **Get PR information:** Use the github cli ( `gh pr view $arguments`) to get the pr details.
2. **Read implementation guidelines:** Read the relevant guideline files based on the code being reviewed.
3. **Explore changes:** Use "gh pr diff $arguments" to check for code changes.
4. **Do code review:** Check the details of the PR and perform a code review following the implementation guidelines.
5. **Run review:** Perform code reviews according to `Important Guidelines for Write a Comment` and implementation guidelines.
6. **Report review results** Instead of using something like create pull_request_review, save the review results in `.tmp`. Add a comment to a line that has improvements or concerns. If revisions are clear, use the suggestions proactively.

**Important Guidelines for Writing Comments**

- **Inline Comment Structure:**

  - **Leave with conclusion:** Use the one-line summary of the main point to write code differences, number of lines, filenames and review content.
  - **Reasoning and suggestions:** After the conclusion, provide detailed explanation of your reasoning, background, and specific suggestions.
  - **Focus on issues:** Inline comments should focus on specific improvements like bug fixes, potential bugs, or readability issues.

- **Regarding Positive Feedback:**

  - **Be selective inline:** Only mention exceptional design choices or innovative implementations that other developers can learn from.
  - **Summarize positives:** Consolidate overall positive aspects and general impressions in the summary comment when submitting the review.

- **Review Format**
  - **Write a review in Markdown**: Save the review results to `.tmp`.
  - **Write a review in Japanese**: Please write code reviews in the format below.

---

# PR番号とタイトル

## 変更概要

## 変更があったファイルの目的と変更内容

## コード変更の詳細分析

## レビューコメント

### 良い点

### 改善点・確認点

### 「レビューの観点」に対するコメント

#### 実装ガイドライン準拠性の評価

## 結論

---

**Review Perspectives**

Focus on the following aspects during review:

**🎯 Implementation Guidelines Compliance (MANDATORY)**

**For Frontend Code (`@~/.claude/templates/frontend-implementation-guidelines.md`):**
- ✅ **Principle 1**: Separation of Concerns Through Custom Hooks
- ✅ **Principle 2**: Comprehensive Error Handling with ErrorScreen components
- ✅ **Principle 3**: Loading State Management with LoadingScreen components
- ✅ **Principle 4**: Performance Optimization Through Memoization
- ✅ **Principle 5**: Type Safety with TypeScript
- ✅ **Principle 6**: Component Decomposition
- ✅ **Principle 7**: Declarative UI Design
- ✅ **Principle 8**: Centralized Data Management
- ✅ **Principle 9**: Externalization of Constants
- ✅ **Principle 10**: Avoiding Props Drilling

**For Backend Code (`@~/.claude/templates/backend-implementation-guidelines.md`):**
- ✅ **Principle 1**: Layered Architecture with Clear Boundaries
- ✅ **Principle 2**: Result-Based Error Handling and Logging
- ✅ **Principle 3**: Input Validation and Type Safety
- ✅ **Principle 4**: Dependency Injection for Testability
- ✅ **Principle 5**: Transaction Management
- ✅ **Principle 6**: Authentication and Authorization
- ✅ **Principle 7**: Consistent API Design
- ✅ **Principle 8**: Performance Optimization
- ✅ **Principle 9**: Security by Design
- ✅ **Principle 10**: Observable and Debuggable
- ✅ **Principle 11**: Reliability Engineering
- ✅ **Principle 12**: Scalability and Continuous Learning

**General Code Quality (Secondary)**
- Compliance with CLAUDE.md guidelines
- Adherence to code quality and best practices
  - Separate responsibilities properly
  - Maximize code reusability
  - Avoid unnecessary code
  - Return all API data unless performance impact is significant
  - Verify object equality in tests
  - Apply consistent styling throughout the app
  - Maintain variable naming consistency
  - Display frontend errors in Japanese, avoid raw responses
  - Consider appropriate processing location (backend vs frontend)
- Check for bugs or security risks
- Identify performance concerns
- Ensure maintainability and readability
- Validate design and architecture decisions

**Additional Notes**

- Provide feedback in Japanese.
- Give specific and actionable feedback.

think super hard
