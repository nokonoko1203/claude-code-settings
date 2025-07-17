---
allowed-tools: Bash(gemini:*)
description: "Use the Gemini CLI to perform deep web searches and generate detailed reporting."
---

## Gemini Deep Search

`gemini` is google gemini cli. You can use it for web search.

### Your Tasks (MUST follow this workflow):

1. Search Phase: Run multiple searches in parallel using gemini CLI.

- Use the `google_web_search` tool in the Gemini CLI
- You will receive a command like `>/search [arguments]`.
  - Please use the google_web_search tool in the Gemini CLI to search for the arguments you received as follows.
  - !`gemini -m gemini-2.5-flash -p "google_web_search: [arguments]'`
- Search for 2-3 keywords individually in parallel (not combined)
- Extract URLs only from search results (do not process HTML content)
- The model used is "gemini-2.5-flash" and no other models

1. Content Extraction Phase: Use readability MCP to extract clean content `mcp__readability__read_url_content_as_markdown`

- Apply this to the most relevant URLs from step 1
- This removes HTML tags and extracts only the main content
- IMPORTANT: Do NOT summarize or process the search results before using this tool (to minimize token consumption)

2. Report Generation Phase: Combine the extracted markdown content into a comprehensive report

- Synthesize information from multiple sources
- Create a structured markdown report

### Critical Rules

- Execute ALL steps within the Task Tool to minimize Claude token consumption
- Do NOT use the built-in `Web Search` tool
- Do NOT process or summarize raw HTML search results directly
- Always extract content using readability BEFORE processing
- Include the final detailed report in a markdown file
