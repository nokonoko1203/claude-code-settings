# Claude Code Settings Best Practices

English | [日本語](./README_ja.md)

A repository collecting best practices for Claude Code settings and customization. We will continue to update and improve this repository to make it even better.

**Note:** Some settings in this repository are specifically configured for Japanese users. Please use LLM to translate and adapt them appropriately to your environment.

The configuration files in this repository are designed to be placed under `~/.claude/` directory. By placing these configuration files in the appropriate locations, you can customize Claude Code's behavior and build an efficient development environment.

## Approach

Models are powerful enough now that complex configuration is unnecessary. Over-configuring can actually be counterproductive. This repository focuses on a few high-impact areas only.

- Claude Code has a rich set of slash commands. Master these first — add custom configuration later.
    - /resume, /rewind, /fork, /copy: Resume, restore, branch, and copy conversations
    - /review: Review pull requests
    - /simplify: Review and fix changed code
    - /copy: Copy session contents to clipboard
    - /add-dir: Add directories to the search scope
    - /batch: Create multiple PRs for large-scale changes using git worktrees
    - /plan: Run in plan mode
- Agent Teams let you distribute tasks across multiple agents working in parallel. By separating roles such as design, review, implementation, and testing, you can tackle large-scale tasks efficiently.
- Enable official plugins. The LSP plugins `typescript-lsp`, `pyright-lsp`, and `rust-analyzer-lsp` provide accurate code navigation without extra token cost.
- In some cases, prefer CLI tools over MCP. MCP servers consume context on every call. CLI tools can accomplish the same tasks with far fewer tokens. For example, replacing Playwright MCP with Playwright CLI.

## Project Structure

```
claude-code-settings/
├── CLAUDE.md          # Global user guidelines for ~/.claude/ placement
├── LICENSE            # MIT License file
├── README.md          # This file (English)
├── README_ja.md       # Japanese version
├── settings.json      # Claude Code configuration file
├── skills/            # Skill definitions
│   ├── kill-dev-process/
│   │   └── SKILL.md   # Dev process cleanup skill
│   └── playwright-cli/
│       ├── SKILL.md   # Browser automation via Playwright CLI (token-efficient)
│       └── references/ # Detailed reference docs
└── symlinks/          # External tools config files as symbolic links
    └── claude.json    # Claude Code MCP server configuration template
```

## About the symlinks Folder

The `symlinks/` folder contains configuration files for various external tools related to Claude Code. Since Claude Code is frequently updated and configuration changes are common, having all configuration files centralized in one folder makes editing much easier. Even if related files are normally placed outside the `~/.claude/` directory, it's convenient to place them here as symbolic links for unified management.

In actual environments, these files are placed as symbolic links in specified locations.

```bash
# Link Claude Code configuration
ln -s /path/to/settings.json ~/.claude/settings.json
```

This allows configuration changes to be managed in the repository and shared across multiple environments.

## Key Features

### 1. Skills

This repository provides skills to enhance Claude Code's capabilities:

**Skills** - User-invocable commands for common tasks:
- Dev process cleanup
- Token-efficient browser automation via Playwright CLI

### 2. Interactive Development Workflow

Rules defined in CLAUDE.md promote interactive development with Claude Code:
- Follow the order: research → plan → approval → implement. No code before approval.
- Write research findings and plans as markdown in `.tmp` so the user can review and annotate
- Use **AskUserQuestion** to support user decision-making
- **Always launch the task management system** when tasks arise to organize details clearly

### 3. Efficient Development Rules

- **Leverage Context7 MCP**: Always reference the latest library information
- **Token-efficient browser automation**: Use Playwright CLI instead of MCP for ~4x token reduction
- **LSP for code investigation**: Accurate code navigation and analysis

### 4. Team Workflow

Agent teams follow a structured formation:
- **Lead + Reviewer**: Claude Code agents handling design and review
- **Implementer + Tester**: Claude Code agents for implementation and testing

This separation of concerns ensures quality through independent review and implementation roles.

## File Details

### CLAUDE.md

Defines global user guidelines. Contains the following content:

- **Top-Level Rules**: Basic operational rules including MCP usage, testing requirements, and team workflows
- Always use Context7 MCP for library information
- Use LSP for accurate code navigation and analysis
- Verify frontend functionality with Playwright CLI (`playwright-cli` via Bash)
- Use `playwright-cli console` and `playwright-cli network` for console logs and network requests
- Do not write code before approval. Follow the order: research → plan → approval → implement
- Write research findings and plans as markdown in `.tmp` — never report only verbally
- Address all user annotations on plans and do not implement until explicitly told to
- Use AskUserQuestion for decision-making
- Respond critically without pandering, but not forcefully
- Always launch the task management system for tasks
- Team formation: Lead + Reviewer (Claude Code agents) and Implementer + Tester (Claude Code agents)

### settings.json

Configuration file that controls Claude Code behavior:

#### Environment Variable Configuration (`env`)
```json
{
  "DISABLE_TELEMETRY": "1",                         // Disable telemetry
  "DISABLE_ERROR_REPORTING": "1",                   // Disable error reporting
  "DISABLE_BUG_COMMAND": "1",                       // Disable bug command
  "API_TIMEOUT_MS": "600000",                       // API timeout (10 minutes)
  "DISABLE_AUTOUPDATER": "0",                       // Auto-updater setting
  "CLAUDE_CODE_ENABLE_TELEMETRY": "0",              // Claude Code telemetry
  "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",  // Disable non-essential traffic
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"       // Enable experimental agent teams
}
```

#### Permission Configuration (`permissions`)

Designed for Bypass mode operation — no allowlist is configured. Only a deny list provides minimal safety guards.

**deny (blocklist)**:
- Dangerous commands: `sudo`, `rm`, `rm -rf`
- Git operations: `git push`, `git reset`, `git rebase`, `git rm`, `git clean`
- Network operations: `curl`, `wget`, `nc`

#### Hook Configuration (`hooks`)

**Notification** (Notification settings - macOS)
- Display notifications with custom messages and titles using macOS notification system

#### MCP Server Activation (`enabledMcpjsonServers`)

Controls which MCP servers defined in project-level `.mcp.json` files are activated.

- **context7** - Up-to-date documentation and code examples for libraries

#### Additional Configuration
- `cleanupPeriodDays`: 20 - Cleanup period for old data
- `enableAllProjectMcpServers`: true - Enable all project-specific MCP servers
- `language`: "Japanese" - Interface language
- `alwaysThinkingEnabled`: true - Always show thinking process
- `enabledPlugins`: LSP plugins for enhanced code intelligence (rust-analyzer, typescript, pyright)

### Official Plugins

Claude Code provides official LSP (Language Server Protocol) plugins for enhanced code intelligence. These are configured in `settings.json` under `enabledPlugins`.

| Plugin              | Description                                           |
| ------------------- | ----------------------------------------------------- |
| `rust-analyzer-lsp` | Rust language server for code navigation and analysis |
| `typescript-lsp`    | TypeScript/JavaScript language server                 |
| `pyright-lsp`       | Python language server for type checking and analysis |

### Skills (skills/)

Skills are user-invocable commands that can be called directly using the `/skill-name` syntax.

| Skill               | Description                                                                     |
| ------------------- | ------------------------------------------------------------------------------- |
| `/kill-dev-process` | Kill orphaned dev servers, browsers, and port-hogging processes                 |
| `/playwright-cli`   | Token-efficient browser automation via Playwright CLI (replaces Playwright MCP) |

## Quick Install (curl)

You can quickly download and set up the configuration files using curl without cloning the repository.

> **WARNING: This will overwrite existing files!**
>
> If you have already customized files such as `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, or any files in `~/.claude/skills/`, **they will be overwritten and your custom settings will be lost**.
>
> **Before running these commands:**
> 1. Back up your existing `~/.claude/` directory: `cp -r ~/.claude ~/.claude.backup`
> 2. Or selectively download only the files you need

### Download All Files

```bash
# Create necessary directories
mkdir -p ~/.claude/skills/{kill-dev-process,playwright-cli}

# Download main configuration files
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md
curl -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/settings.json

# Download skills
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
curl -o ~/.claude/skills/playwright-cli/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/playwright-cli/SKILL.md
```

### Download Individual Files

If you only want specific files, you can download them individually:

```bash
# Example: Download only the CLAUDE.md
mkdir -p ~/.claude
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md

# Example: Download only a specific skill
mkdir -p ~/.claude/skills/kill-dev-process
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
```

## References

- [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [Context7](https://context7.com/)
- [Playwright CLI](https://www.npmjs.com/package/@playwright/cli)

## License

This project is released under the MIT License.
