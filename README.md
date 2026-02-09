# Claude Code Settings Best Practices

English | [日本語](./README_ja.md)

A repository collecting best practices for Claude Code settings and customization. We will continue to update and improve this repository to make it even better.

**Note:** Some settings in this repository are specifically configured for Japanese users. Please use LLM to translate and adapt them appropriately to your environment.

The configuration files in this repository are designed to be placed under `~/.claude/` directory. By placing these configuration files in the appropriate locations, you can customize Claude Code's behavior and build an efficient development environment.

## Project Structure

```
claude-code-settings/
├── .mcp.json          # MCP servers configuration file
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
│   ├── bug-investigation/
│   │   └── SKILL.md   # Bug investigation and analysis skill
│   ├── code-review/
│   │   └── SKILL.md   # Comprehensive code review skill (PR review + self-review + quality check)
│   ├── codex-consult/
│   │   └── SKILL.md   # Codex MCP delegation skill for implementation/review/testing
│   ├── design-principles/
│   │   └── SKILL.md   # Design system enforcement skill
│   ├── humanize-text/
│   │   └── SKILL.md   # AI-written Japanese text humanization skill
│   └── kill-dev-process/
│       └── SKILL.md   # Dev process cleanup skill
└── symlinks/          # External tools config files as symbolic links
    ├── claude.json    # Claude Code user stats and settings cache
    ├── ccmanager/     # → ~/.config/ccmanager (CCManager configuration)
    │   ├── config.json     # CCManager settings and command presets
    │   └── init_worktree.sh # Worktree post-creation hook script
    └── codex/         # → ~/.codex (Codex MCP configuration)
        ├── AGENTS.md  # Codex project guidelines
        ├── config.toml # Codex CLI configuration
        └── skills/    # Codex skills (synced from Claude Code skills)
            ├── bug-investigation/
            ├── code-review/
            ├── design-principles/
            ├── humanize-text/
            └── kill-dev-process/
```

## About the symlinks Folder

The `symlinks/` folder contains configuration files for various external tools related to Claude Code. Since Claude Code is frequently updated and configuration changes are common, having all configuration files centralized in one folder makes editing much easier. Even if related files are normally placed outside the `~/.claude/` directory, it's convenient to place them here as symbolic links for unified management.

In actual environments, these files are placed as symbolic links in specified locations.

```bash
# Link Claude Code configuration
ln -s /path/to/settings.json ~/.claude/settings.json

# Link ccmanager configuration
ln -s ~/.config/ccmanager ~/.claude/symlinks/ccmanager

# Link Codex configuration
ln -s ~/.codex ~/.claude/symlinks/codex
```

This allows configuration changes to be managed in the repository and shared across multiple environments.

### Codex Configuration (`symlinks/codex/`)

The `codex/` symlink contains Codex CLI configuration for use with Codex MCP:

- **`config.toml`** - Codex CLI settings including model selection, sandbox mode, MCP servers, and model providers
- **`AGENTS.md`** - Project guidelines that Codex follows (similar to CLAUDE.md but without Claude Code-specific rules like team formation)
- **`skills/`** - Codex-compatible versions of Claude Code skills (bug-investigation, code-review, design-principles, humanize-text, kill-dev-process)

## Key Features

### 1. Custom Agents and Skills

This repository provides specialized agents and skills to enhance Claude Code's capabilities:

**Agents** - Specialized agents for specific domains:
- Backend/API design and implementation expertise
- Frontend development and design review

**Skills** - User-invocable commands for common tasks:
- Code review with implementation guidelines
- Codex MCP delegation for implementation, review, and testing
- Design system enforcement
- Bug investigation with root cause analysis
- AI-written Japanese text humanization
- Dev process cleanup

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

### 4. Team Workflow with Codex MCP

Agent teams follow a structured formation:
- **Lead + Reviewer**: Claude Code agents handling design and review
- **Implementer + Tester**: Claude Code agents delegating to Codex MCP via `/codex-consult` skill

This separation of concerns ensures quality through independent review and implementation roles.

## File Details

### CLAUDE.md

Defines global user guidelines. Contains the following content:

- **Top-Level Rules**: Basic operational rules including MCP usage, testing requirements, and team workflows
- Always use Context7 MCP for library information
- Use LSP for accurate code navigation and analysis
- Verify frontend functionality with Playwright MCP or Chrome DevTools MCP
- Use Chrome DevTools MCP for console log checking
- Use AskUserQuestion for decision-making
- Create temporary design notes in `.tmp`
- Respond critically without pandering, but not forcefully
- Always launch the task management system for tasks
- Team formation: Lead + Reviewer (Claude Code agents) and Implementer + Tester (Codex MCP via `/codex-consult`)

### .mcp.json

Defines MCP (Model Context Protocol) servers available for use:

| Server | Description |
| --- | --- |
| **context7** | Up-to-date documentation and code examples for libraries |
| **playwright** | Browser automation and testing |
| **chrome-devtools** | Chrome DevTools integration for console logs and debugging |
| **codex** | Codex MCP for delegating implementation, review, and testing tasks |

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

**allow (allowlist)**:
- File reading: `Read(**)`
- Writing to specific directories: `Write(src/**)`, `Write(docs/**)`, `Write(.tmp/**)`
- Package management: `pnpm install`, `pnpm run test`, `pnpm run build`
- File operations: `rm`
- Basic shell commands: `ls`, `cat`, `head`, `tail`, `pwd`, `find`, `tree`, `mkdir`, `mv`
- Docker operations: `docker compose up -d --build`
- macOS notifications: `osascript -e`

**deny (blocklist)**:
- Dangerous commands: `sudo`, `rm`, `rm -rf`
- Git operations: `git push`, `git commit`, `git reset`, `git rebase`, `git rm`, `git clean`
- Security related: Reading `.env.*` files, `id_rsa`, `id_ed25519`, tokens, keys
- Writing sensitive files: `.env*`, `**/secrets/**`
- Network operations: `curl`, `wget`, `nc`
- Package removal: `npm uninstall`, `npm remove`
- Direct database operations: `psql`, `mysql`
- Specific Serena MCP tools: `create_text_file`, `delete_lines`, `execute_shell_command`, `replace_lines`, `replace_regex`

> **Note:** `rm` appears in both allow and deny lists. Since deny takes precedence, `rm` commands require explicit approval.

#### Hook Configuration (`hooks`)

**PostToolUse** (Automatic processing after tool use)
- Automatic Prettier formatting when editing JS/TS/JSON/TSX files

**Notification** (Notification settings - macOS)
- Display notifications with custom messages and titles using macOS notification system

**Stop** (Processing when work is completed)
- Display "作業が完了しました" (Work completed) notification

#### MCP Server Activation (`enabledMcpjsonServers`)

Controls which MCP servers defined in `.mcp.json` are activated. Note that `serena` is defined at the project level (not in the global `.mcp.json`), while `codex` in `.mcp.json` is activated via `enableAllProjectMcpServers: true`.

- **context7** - Up-to-date documentation and code examples for libraries
- **playwright** - Browser automation and testing
- **serena** - Semantic code analysis and intelligent code navigation
- **chrome-devtools** - Chrome DevTools integration

#### Additional Configuration
- `cleanupPeriodDays`: 20 - Cleanup period for old data
- `enableAllProjectMcpServers`: true - Enable all project-specific MCP servers
- `language`: "Japanese" - Interface language
- `alwaysThinkingEnabled`: true - Always show thinking process
- `enabledPlugins`: LSP plugins for enhanced code intelligence (rust-analyzer, typescript, pyright)

### Custom Agents (agents/)

Custom agents provide specialized capabilities for specific development tasks. These agents are automatically available when using Claude Code and can be invoked through the Task tool.

| Agent                              | Description                                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------------------------- |
| `backend-design-expert`            | Code-agnostic backend/API expert for specification-first design and operational correctness |
| `backend-implementation-engineer`  | Implements backend HTTP APIs using Hono + TypeScript with clean architecture                |
| `frontend-design-expert`           | Code-agnostic frontend reviewer for SPA/SSR apps, audits architecture and performance       |
| `frontend-implementation-engineer` | Implements production-ready web apps using Svelte 5 + SvelteKit + TypeScript                |

### Official Plugins

Claude Code provides official LSP (Language Server Protocol) plugins for enhanced code intelligence. These are configured in `settings.json` under `enabledPlugins`.

| Plugin               | Description                                                |
| -------------------- | ---------------------------------------------------------- |
| `rust-analyzer-lsp`  | Rust language server for code navigation and analysis      |
| `typescript-lsp`     | TypeScript/JavaScript language server                      |
| `pyright-lsp`        | Python language server for type checking and analysis      |

### Skills (skills/)

Skills are user-invocable commands that can be called directly using the `/skill-name` syntax.

| Skill                  | Description                                                                     |
| ---------------------- | ------------------------------------------------------------------------------- |
| `/bug-investigation`   | Systematically investigate bugs with root cause analysis and fix proposals      |
| `/code-review`         | Comprehensive code review combining PR review, self-review, and quality checks  |
| `/codex-consult`       | Delegate tasks to Codex MCP for implementation, review, testing, or design consultation |
| `/design-principles`   | Enforce precise, minimal design system inspired by Linear, Notion, and Stripe   |
| `/humanize-text`       | Transform AI-written Japanese text into natural, human-like Japanese            |
| `/kill-dev-process`    | Kill orphaned dev servers, browsers, and port-hogging processes                 |

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
mkdir -p ~/.claude/skills/{bug-investigation,code-review,codex-consult,design-principles,humanize-text,kill-dev-process}

# Download main configuration files
curl -o ~/.claude/CLAUDE.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/CLAUDE.md
curl -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/settings.json
curl -o ~/.claude/.mcp.json \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/.mcp.json

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
curl -o ~/.claude/skills/bug-investigation/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/bug-investigation/SKILL.md
curl -o ~/.claude/skills/code-review/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/code-review/SKILL.md
curl -o ~/.claude/skills/codex-consult/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/codex-consult/SKILL.md
curl -o ~/.claude/skills/design-principles/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/design-principles/SKILL.md
curl -o ~/.claude/skills/humanize-text/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/humanize-text/SKILL.md
curl -o ~/.claude/skills/kill-dev-process/SKILL.md \
  https://raw.githubusercontent.com/nokonoko1203/claude-code-settings/main/skills/kill-dev-process/SKILL.md
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
- [OpenAI Codex](https://openai.com/codex)
- [textlint](https://textlint.github.io/)
- [CCManager](https://github.com/kbwo/ccmanager)
- [Context7](https://context7.com/)

## License

This project is released under the MIT License.
