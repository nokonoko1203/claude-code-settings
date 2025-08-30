# Claude Code Settings Best Practices

A repository collecting best practices for Claude Code settings and customization. We will continue to update and improve this repository to make it even better.

**Note:** Some settings in this repository are specifically configured for Japanese users. Please use LLM to translate and adapt them appropriately to your environment.

The configuration files in this repository are designed to be placed under `~/.claude/` directory. By placing these configuration files in the appropriate locations, you can customize Claude Code's behavior and build an efficient development environment.

## Project Structure

```
claude-code-settings/
├── CLAUDE.md          # Global user guidelines for ~/.claude/ placement
├── settings.json      # Claude Code configuration file
├── commands/          # Custom command definitions
│   ├── code-review.md    # Execute code review with detailed analysis
│   ├── d-search.md       # Deep codebase analysis using gemini-cli
│   ├── design.md         # Technical design phase execution
│   ├── learn.md          # WebGIS-focused educational code analysis using Serena MCP
│   ├── marp.md          # Marp presentation creation command
│   ├── obs.md           # Natural language Obsidian assistant for fleeting notes and tasks
│   ├── requirements.md   # Requirements definition phase execution
│   ├── search.md        # Google web search using gemini-cli
│   ├── serena.md        # Token-efficient Serena MCP command for structured app development
│   ├── spec.md          # Complete specification-driven development workflow
│   ├── tasks.md         # Task breakdown phase execution
│   ├── test-design.md   # Test specification creation (Stage 3 of Spec-Driven Development)
│   └── textlint.md      # File proofreading and correction with textlint
├── templates/         # Implementation guideline templates
│   ├── backend-implementation-guidelines.md   # Backend development best practices
│   └── frontend-implementation-guidelines.md  # Frontend development best practices
└── symlinks/         # External tools config files as symbolic links
    ├── claude.json      # Claude Code global configuration
    ├── settings.json    # Claude Code settings with MCP configurations
    └── config/
        ├── ccmanager/
        │   └── config.json    # ccmanager: Claude Code project & git worktree manager
        └── serena/
            └── serena_config.yml  # Serena MCP configuration
```

## About the symlinks Folder

The `symlinks/` folder contains configuration files for various external tools related to Claude Code. Since Claude Code is frequently updated and configuration changes are common, having all configuration files centralized in one folder makes editing much easier. Even if related files are normally placed outside the `~/.claude/` directory, it's convenient to place them here as symbolic links for unified management.

In actual environments, these files are placed as symbolic links in specified locations.

```bash
# Link Claude Code configuration
ln -s /path/to/settings.json ~/.claude/settings.json

# Link ccmanager configuration
ln -s /path/to/.config/ccmanager/config.json ~/.claude/symlinks/config/ccmanager/config.json

# Link serena configuration
ln -s /path/to/.config/serena/serena_config.yml ~/.claude/symlinks/config/serena/serena_config.yml
```

This allows configuration changes to be managed in the repository and shared across multiple environments.

## About the templates Folder

The `templates/` folder contains implementation guideline templates that provide best practices for frontend and backend development. These templates serve as comprehensive references for LLM code generation, ensuring consistent, high-quality, and maintainable code across projects.

### Frontend Implementation Guidelines
- **10 Universal Principles**: Separation of concerns, error handling, performance optimization, type safety
- **React Best Practices**: Custom hooks, component decomposition, state management patterns
- **WebGIS Optimization**: Specialized patterns for geographic data visualization and mapping applications

### Backend Implementation Guidelines  
- **Architecture Patterns**: Clean architecture, dependency injection, domain-driven design
- **API Design**: RESTful endpoints, GraphQL schemas, error handling strategies
- **Database Management**: Query optimization, connection pooling, migration strategies

These templates can be referenced during development to ensure consistency with established patterns and best practices.

## Key Features

### 1. Specification-Driven Development Workflow

The biggest feature of this project is the 5-stage specification-driven development workflow:

1. **Requirements Definition** (`/requirements`) - Convert user requests into clear functional requirements
2. **Design** (`/design`) - Formulate technical design and architecture
3. **Test Design** (`/test-design`) - Create comprehensive test specification based on design
4. **Task Breakdown** (`/tasks`) - Divide tasks into implementable units
5. **Implementation** - Systematic implementation based on task list

**Note:** The design documents generated by these slash commands are output in Japanese due to the prompts configured in each command.

### 2. Efficient Development Rules

- **Utilize parallel processing**: Multiple independent processes are executed simultaneously
- **Think in English, respond in Japanese**: Internal processing in English, user responses in Japanese
- **Leverage Context7 MCP**: Always reference the latest library information
- **Thorough verification**: Always verify with Read after Write/Edit

## File Details

### CLAUDE.md

Defines project-specific guidelines. Contains the following content:

- **Top-Level Rules**: Basic operational rules
- **Programming Rules**: Coding conventions (when using TypeScript, etc.)
- **Development Style**: Detailed specification-driven development workflow

### settings.json

Configuration file that controls Claude Code behavior:

#### Environment Variable Configuration (`env`)
```json
{
  "DISABLE_TELEMETRY": "1",        // Disable telemetry
  "DISABLE_ERROR_REPORTING": "1",   // Disable error reporting
  "API_TIMEOUT_MS": "600000"        // API timeout (10 minutes)
}
```

#### Permission Configuration (`permissions`)

**allow (allowlist)**:
- File reading: `Read(**)`
- Writing to specific directories: `Write(src/**)`, `Write(docs/**)`, `Write(.tmp/**)`
- Git operations: `git init`, `git add`, `git commit`, `git push origin*`
- Package management: `npm install`, `pnpm install`
- MCP related: Use tools like Context7, Playwright, etc.

**deny (blocklist)**:
- Dangerous commands: `sudo`, `rm -rf`
- Security related: Reading `.env.*` files, `id_rsa`, etc.
- Direct database operations: `psql`, `mysql`, etc.

#### Hook Configuration (`hooks`)

**PostToolUse** (Automatic processing after tool use)
- Record command history (Bash, Read, Write, etc.)
- Automatic textlint execution when editing Markdown files

**Notification** (Notification settings - macOS)
- Display work progress notifications

**Stop** (Processing when work is completed)
- Display completion notifications

#### MCP Server Configuration (`enabledMcpjsonServers`)
- GitHub integration (multiple account support)
- Context7 (document retrieval)
- Playwright (browser automation)
- Readability (web article reading)
- textlint (Japanese proofreading)
- Obsidian MCP (note management)
- Serena (semantic code analysis)

### Custom Commands (commands/)

#### Specification-Driven Development Commands

| Command         | Stage | Description                                        |
| --------------- | ----- | -------------------------------------------------- |
| `/spec`         | All   | Complete specification-driven development workflow |
| `/requirements` | 1     | Requirements definition phase execution            |
| `/design`       | 2     | Technical design phase execution                   |
| `/test-design`  | 3     | Test specification creation                        |
| `/tasks`        | 4     | Task breakdown phase execution                     |

#### Analysis and Review Commands

| Command         | Description                                        |
| --------------- | -------------------------------------------------- |
| `/code-review`  | Execute code review with detailed analysis         |
| `/learn`        | WebGIS-focused educational code analysis using Serena MCP |
| `/serena`       | Token-efficient Serena MCP command for structured app development |

#### Search and Research Commands

| Command         | Description                                        |
| --------------- | -------------------------------------------------- |
| `/search`       | Google web search using gemini-cli                 |
| `/d-search`     | Deep codebase analysis using gemini-cli            |

#### Productivity and Documentation Commands

| Command         | Description                                        |
| --------------- | -------------------------------------------------- |
| `/obs`          | Natural language Obsidian assistant for fleeting notes and tasks |
| `/marp`         | Marp presentation creation command                 |
| `/textlint`     | File proofreading and correction with textlint     |

### Implementation Templates (templates/)

The templates directory provides comprehensive implementation guidelines:

| Template                                    | Purpose                                           |
| ------------------------------------------- | ------------------------------------------------- |
| `frontend-implementation-guidelines.md`     | Frontend development best practices and patterns   |
| `backend-implementation-guidelines.md`      | Backend architecture and API design guidelines    |

These templates serve as reference guides for maintaining code quality and consistency across projects, especially when working with LLM-generated code.

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/nokonoko1203/claude-code-settings.git
cd claude-code-settings
```

### 2. Apply Configuration to Claude Code

You can either copy the repository contents to `~/.claude/` or create a symbolic link to keep it synchronized with the repository.

#### Option A: Copy Contents to ~/.claude/
```bash
# Copy configuration files to ~/.claude/ directory
cp CLAUDE.md ~/.claude/
cp settings.json ~/.claude/
cp .textlintrc.json ~/.claude/
cp -r commands ~/.claude/
cp -r templates ~/.claude/
cp -r symlinks ~/.claude/
```

#### Option B: Link Repository to ~/.claude/ (Recommended)
```bash
# Create symbolic link to keep repository synchronized
ln -s /path/to/claude-code-settings ~/.claude/claude-code-settings
# Then link individual files
ln -s ~/.claude/claude-code-settings/CLAUDE.md ~/.claude/
ln -s ~/.claude/claude-code-settings/settings.json ~/.claude/
ln -s ~/.claude/claude-code-settings/commands ~/.claude/
ln -s ~/.claude/claude-code-settings/templates ~/.claude/
```

### 3. Configure External Tools Using Symbolic Links

Create symbolic links from external tool locations to `~/.claude/symlinks/` for centralized management:

```bash
# Create symlinks directory structure
mkdir -p ~/.claude/symlinks/config/ccmanager/
mkdir -p ~/.claude/symlinks/config/serena/

# Link Claude Code global configuration to symlinks folder
ln -s ~/claude.json ~/.claude/symlinks/claude.json

# Link ccmanager configuration to symlinks folder
ln -s ~/.config/ccmanager/config.json ~/.claude/symlinks/config/ccmanager/config.json

# Link serena configuration to symlinks folder
ln -s ~/.config/serena/serena_config.yml ~/.claude/symlinks/config/serena/serena_config.yml
```

This approach centralizes all Claude Code-related configuration files in the `~/.claude/` directory for easier management.

## References

- [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://docs.anthropic.com/en/docs/mcp)
- [textlint](https://textlint.github.io/)
- [CCManager](https://github.com/kbwo/ccmanager)
- [Context7](https://context7.com/)

## License

This project is released under the MIT License.
