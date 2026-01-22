# Claude Code Settings Best Practices

English | [日本語](./README_ja.md)

A repository collecting best practices for Claude Code settings and customization. We will continue to update and improve this repository to make it even better.

**Note:** Some settings in this repository are specifically configured for Japanese users. Please use LLM to translate and adapt them appropriately to your environment.

The configuration files in this repository are designed to be placed under `~/.claude/` directory. By placing these configuration files in the appropriate locations, you can customize Claude Code's behavior and build an efficient development environment.

## Project Structure

```
claude-code-settings/
├── .textlintrc.json   # textlint configuration file
├── CLAUDE.md          # Global user guidelines for ~/.claude/ placement
├── LICENSE            # MIT License file
├── README.md          # This file (English)
├── README_ja.md       # Japanese version
├── agents/            # Custom agent definitions
│   ├── backend-design-expert.md           # Backend/API design expert
│   ├── backend-implementation-engineer.md # Hono + TypeScript backend implementation
│   ├── frontend-design-expert.md          # Frontend design reviewer
│   └── frontend-implementation-engineer.md # Svelte 5 + SvelteKit implementation
├── settings.json      # Claude Code configuration file
├── skills/            # Skill definitions
│   ├── agent-browser/
│   │   └── SKILL.md   # Browser automation skill
│   ├── agent-memory/
│   │   └── SKILL.md   # Persistent memory management skill
│   ├── bug-investigation/
│   │   └── SKILL.md   # Bug investigation and analysis skill
│   ├── code-review/
│   │   └── SKILL.md   # Comprehensive code review skill (PR review + self-review + quality check)
│   ├── design-principles/
│   │   └── SKILL.md   # Design system enforcement skill
│   └── textlint/
│       └── SKILL.md   # Markdown linting skill
└── symlinks/          # External tools config files as symbolic links
    ├── claude.json
    └── config/
        ├── ccmanager/
        │   └── config.json
        └── serena/
            └── serena_config.yml  # Serena MCP configuration (symlink)
```

## About the symlinks Folder

The `symlinks/` folder contains configuration files for various external tools related to Claude Code. Since Claude Code is frequently updated and configuration changes are common, having all configuration files centralized in one folder makes editing much easier. Even if related files are normally placed outside the `~/.claude/` directory, it's convenient to place them here as symbolic links for unified management.

In actual environments, these files are placed as symbolic links in specified locations.

```bash
# Link Claude Code configuration
ln -s /path/to/settings.json ~/.claude/settings.json

# Link ccmanager configuration
ln -s /path/to/.config/ccmanager/config.json ~/.claude/symlinks/config/ccmanager/config.json
```

This allows configuration changes to be managed in the repository and shared across multiple environments.

## Key Features

### 1. Custom Agents and Skills

This repository provides specialized agents and skills to enhance Claude Code's capabilities:

**Agents** - Specialized agents for specific domains:
- Backend/API design and implementation expertise
- Frontend development and design review

**Skills** - User-invocable commands for common tasks:
- Code review with implementation guidelines
- Design system enforcement
- Quality checks and linting

### 2. Interactive Development Workflow

Leverage Claude Code's built-in Plan Mode and AskUserQuestion features to:
- Clarify requirements through interactive dialogue
- Create detailed implementation plans before coding
- Ensure alignment with user intent throughout development
- Systematically approach complex tasks

This interactive approach ensures specifications are clear before implementation begins.

### 3. Efficient Development Rules

- **Utilize parallel processing**: Multiple independent processes are executed simultaneously
- **Think in English, respond in Japanese**: Internal processing in English, user responses in Japanese
- **Leverage Context7 MCP**: Always reference the latest library information
- **Thorough verification**: Always verify with Read after Write/Edit

## File Details

### CLAUDE.md

Defines project-specific guidelines. Contains the following content:

- **Top-Level Rules**: Basic operational rules including language preference, MCP usage, and testing requirements
- Responses must be in Japanese
- Always use Context7 MCP for library information
- Always use Serena MCP for code investigation
- Verify frontend functionality with Playwright MCP or Chrome DevTools MCP
- Use AskUserQuestion for decision-making

### settings.json

Configuration file that controls Claude Code behavior:

#### Environment Variable Configuration (`env`)
```json
{
  "DISABLE_TELEMETRY": "1",                      // Disable telemetry
  "DISABLE_ERROR_REPORTING": "1",                // Disable error reporting
  "DISABLE_BUG_COMMAND": "1",                    // Disable bug command
  "API_TIMEOUT_MS": "600000",                    // API timeout (10 minutes)
  "DISABLE_AUTOUPDATER": "0",                    // Auto-updater setting
  "CLAUDE_CODE_ENABLE_TELEMETRY": "0",           // Claude Code telemetry
  "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1" // Disable non-essential traffic
}
```

#### Permission Configuration (`permissions`)

**allow (allowlist)**:
- File reading: `Read(**)`
- Writing to specific directories: `Write(src/**)`, `Write(docs/**)`, `Write(.tmp/**)`
- Package management: `pnpm install`, `pnpm run test`, `pnpm run build`
- Basic shell commands: `ls`, `cat`, `head`, `tail`, `pwd`, `find`, `tree`, `mkdir`, `mv`
- Docker operations: `docker compose up -d --build`
- macOS notifications: `osascript -e`

**deny (blocklist)**:
- Dangerous commands: `sudo`, `rm -rf`
- Git operations: `git push`, `git commit`, `git reset`, `git rebase`
- Security related: Reading `.env.*` files, `id_rsa`, `id_ed25519`, tokens, keys
- Writing sensitive files: `.env*`, `**/secrets/**`
- Network operations: `curl`, `wget`, `nc`
- Package removal: `npm uninstall`, `npm remove`
- Direct database operations: `psql`, `mysql`, `mongod`
- Specific Serena MCP tools: `create_text_file`, `delete_lines`, `execute_shell_command`, `replace_lines`, `replace_regex`

#### Hook Configuration (`hooks`)

**PostToolUse** (Automatic processing after tool use)
- Automatic Prettier formatting when editing JS/TS/JSON/TSX files

**Notification** (Notification settings - macOS)
- Display notifications with custom messages and titles using macOS notification system

**Stop** (Processing when work is completed)
- Display "作業が完了しました" (Work completed) notification

#### MCP Server Configuration (`enabledMcpjsonServers`)
- **context7** - Up-to-date documentation and code examples for libraries
- **playwright** - Browser automation and testing
- **serena** - Semantic code analysis and intelligent code navigation
- **chrome-devtools** - Chrome DevTools integration

#### Additional Configuration
- `cleanupPeriodDays`: 20 - Cleanup period for old data
- `enableAllProjectMcpServers`: true - Enable all project-specific MCP servers
- `language`: "Japanese" - Interface language
- `alwaysThinkingEnabled`: true - Always show thinking process
- `model`: "opusplan" - Default model for planning

### Custom Agents (agents/)

Custom agents provide specialized capabilities for specific development tasks. These agents are automatically available when using Claude Code and can be invoked through the Task tool.

| Agent                              | Description                                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------------------------- |
| `backend-design-expert`            | Code-agnostic backend/API expert for specification-first design and operational correctness |
| `backend-implementation-engineer`  | Implements backend HTTP APIs using Hono + TypeScript with clean architecture                |
| `frontend-design-expert`           | Code-agnostic frontend reviewer for SPA/SSR apps, audits architecture and performance       |
| `frontend-implementation-engineer` | Implements production-ready web apps using Svelte 5 + SvelteKit + TypeScript                |

### Official Plugins

Claude Code provides official plugins that can be installed directly from within a Claude Code session. These plugins offer pre-built functionality without requiring manual configuration files.

**Installation:**
```bash
# Update the official plugins marketplace
/plugin marketplace update claude-plugins-official

# Install the code-simplifier plugin
/plugin install code-simplifier
```

| Plugin            | Description                                                                |
| ----------------- | -------------------------------------------------------------------------- |
| `code-simplifier` | Expert in preventing AI-generated code from becoming unnecessarily complex |

### Skills (skills/)

Skills are user-invocable commands that can be called directly using the `/skill-name` syntax.

| Skill                  | Description                                                                    |
| ---------------------- | ------------------------------------------------------------------------------ |
| `/agent-browser`       | Automates browser interactions for web testing, form filling, and screenshots  |
| `/agent-memory`        | Persistent memory management for storing knowledge across conversations        |
| `/bug-investigation`   | Systematically investigate bugs with root cause analysis and fix proposals     |
| `/code-review`         | Comprehensive code review combining PR review, self-review, and quality checks |
| `/design-principles`   | Enforce precise, minimal design system inspired by Linear, Notion, and Stripe  |
| `/textlint`            | Execute textlint on specified files with automatic and manual fixes            |

## Quick Install (curl)

You can quickly download and set up the configuration files using curl without cloning the repository.

> **WARNING: This will overwrite existing files!**
>
> If you have already customized files such as `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, or any files in `~/.claude/agents/` or `~/.claude/skills/`, **they will be overwritten and your custom settings will be lost**.
>
> **Before running these commands:**
> 1. Back up your existing `~/.claude/` directory: `cp -r ~/.claude ~/.claude.backup`
> 2. Or selectively download only the files you need

### Download All Files

```bash
# Create necessary directories
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/skills/{agent-browser,agent-memory,bug-investigation,code-review,design-principles,textlint}

# Download main configuration files
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md
curl -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/settings.json

# Download agents
curl -o ~/.claude/agents/backend-design-expert.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/backend-design-expert.md
curl -o ~/.claude/agents/backend-implementation-engineer.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/backend-implementation-engineer.md
curl -o ~/.claude/agents/frontend-design-expert.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/frontend-design-expert.md
curl -o ~/.claude/agents/frontend-implementation-engineer.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/agents/frontend-implementation-engineer.md

# Download skills
curl -o ~/.claude/skills/agent-browser/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/agent-browser/SKILL.md
curl -o ~/.claude/skills/agent-memory/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/agent-memory/SKILL.md
curl -o ~/.claude/skills/bug-investigation/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/bug-investigation/SKILL.md
curl -o ~/.claude/skills/code-review/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/code-review/SKILL.md
curl -o ~/.claude/skills/design-principles/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/design-principles/SKILL.md
curl -o ~/.claude/skills/textlint/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/textlint/SKILL.md
```

### Download Individual Files

If you only want specific files, you can download them individually:

```bash
# Example: Download only the CLAUDE.md
mkdir -p ~/.claude
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md

# Example: Download only a specific skill
mkdir -p ~/.claude/skills/code-review
curl -o ~/.claude/skills/code-review/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/code-review/SKILL.md
```

## References

- [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [textlint](https://textlint.github.io/)
- [CCManager](https://github.com/kbwo/ccmanager)
- [Context7](https://context7.com/)

## License

This project is released under the MIT License.
