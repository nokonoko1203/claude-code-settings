---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*), Bash(gh pr view:*), Bash(gh pr diff:*)
description: Perform a thorough code review of pull requests following established guidelines, focusing on code quality, best practices, and maintainability while providing constructive feedback
---

## Code Review Rules

Review the pull request specified by the PR number provided in the command arguments.

Usage: `/code-review <PR_NUMBER>`
Example: `/code-review 001`

The PR number will be available as `$ARGUMENTS`.

Review process:

1. **Get PR information:** Use the github cli ( `gh pr view $arguments`) to get the pr details.
2. **Explore changes:** Use "gh pr diff $arguments" to check for code changes.
3. **Do code review:** Check the details of the PR and perform a code review.
4. **Run review:** Perform code reviews according to `Important Guidelines for Write a Comment`".
5. **Report review results** Instead of using something like create pull_request_review, save the review results in `.tmp`. Add a comment to a line that has improvements or concerns. If revisions are clear, use the suggestions proactively.

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

## 変更ファイル

## コード変更の詳細分析

## レビューコメント

### 良い点

### 改善点・確認点

## 結論

---

**Review Perspectives**

Focus on the following aspects during review:

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
