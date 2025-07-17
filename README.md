# Claude Code Settings Best Practices

A repository collecting best practices for Claude Code settings and customization.

## Project Structure

```
claude-code-settings/
├── CLAUDE.md          # Project-specific guidelines
├── settings.json      # Claude Code configuration file
├── commands/          # Custom command definitions
│   ├── code-review.md
│   ├── d-search.md
│   ├── design.md
│   ├── marp.md
│   ├── requirements.md
│   ├── search.md
│   ├── spec.md
│   ├── tasks.md
│   └── textlint.md
└── symlinks/         # Various tool configuration file samples
    ├── settings.json      # Claude Code settings (with prettier)
    └── config/
        └── ccmanager/
            └── config.json    # ccmanager configuration file
```

## About the symlinks Folder

The `symlinks/` folder contains sample configuration files for various tools. When actually used, these files are placed as symbolic links in specified locations to enable unified configuration management.

### Included Configuration Files

#### settings.json (with prettier)
An extended version of the Claude Code configuration file. In addition to basic settings, the following features are added:

- **Prettier automatic execution**: Automatic formatting when editing JavaScript/TypeScript/JSON files
- **Simple MCP server configuration**: Enable only basic MCP servers

#### config/ccmanager/config.json
Configuration file for the ccmanager tool. It provides the following features:

- **Keyboard shortcuts**: Return to menu (Ctrl+E) and cancel (Escape)
- **Automatic worktree creation**: Auto-generate working directories for each branch
- **Command presets**: Multiple Claude Code startup options (resume, YOLO, Gemini CLI)

### Usage

In actual environments, these files are placed as symbolic links in specified locations.

```bash
# Link Claude Code configuration
ln -s /path/to/claude-code-settings/symlinks/settings.json ~/.claude/settings.json

# Link ccmanager configuration
ln -s /path/to/claude-code-settings/symlinks/config/ccmanager/config.json ~/.config/ccmanager/config.json
```

This allows configuration changes to be managed in the repository and shared across multiple environments.

## Key Features

### 1. Specification-Driven Development Workflow

The biggest feature of this project is the 4-stage specification-driven development workflow:

1. **Requirements Definition** (`/requirements`) - Convert user requests into clear functional requirements
2. **Design** (`/design`) - Formulate technical design and architecture
3. **Task Breakdown** (`/tasks`) - Divide tasks into implementable units
4. **Implementation** - Systematic implementation based on task list

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

### Custom Commands (commands/)

| Command         | Description                                              |
| --------------- | -------------------------------------------------------- |
| `/spec`         | Start complete specification-driven development workflow |
| `/requirements` | Execute requirements definition only                     |
| `/design`       | Execute design phase only                                |
| `/tasks`        | Execute task breakdown only                              |
| `/code-review`  | Execute code review                                      |
| `/search`       | Codebase search                                          |
| `/d-search`     | Deep search (detailed analysis)                          |
| `/marp`         | Marp presentation creation                               |
| `/textlint`     | File proofreading and correction with textlint           |

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/[your-username]/claude-code-settings.git
cd claude-code-settings
```

### 2. Apply Configuration to Claude Code

#### Use as Project-Specific Configuration
```bash
# Copy to project root
cp CLAUDE.md /path/to/your/project/
cp settings.json /path/to/your/project/
```

#### Use as Global Configuration
```bash
# Copy to ~/.claude/ directory
cp settings.json ~/.claude/
cp -r commands ~/.claude/
```

### 3. textlint Configuration (Optional)

For automatic Markdown proofreading:

```bash
# Install textlint and required rules
npm install -g textlint
npm install -g textlint-rule-preset-ja-technical-writing

# Place configuration file
cp .textlintrc.json ~/.claude/
```

## Usage Examples

### New Feature Development Example

```
User: Please implement a new user authentication feature

Claude: I'll use the /spec command to start the specification-driven development workflow.

[Stage 1: Executing requirements definition...]
[Stage 2: Executing design...]
[Stage 3: Executing task breakdown...]
[Stage 4: Starting implementation...]
```

### Using Custom Commands

```
User: /search AuthService

Claude: Searching for files related to AuthService...
```

### Document Proofreading with textlint

```
User: /textlint README.md

Claude: Proofreading README.md using textlint...
```

### MCP Tool Usage Example

```
User: Please check the latest Next.js App Router documentation and implement

Claude: I'll use Context7 MCP to retrieve the latest Next.js information...
```

## Customization Guide

### Adding Custom Commands

1. Create a new Markdown file in the `commands/` directory:

```bash
touch commands/my-command.md
```

2. Define the command content:

```markdown
# My Custom Command

This command executes [specific processing content].

## Execution Content
1. [Step 1]
2. [Step 2]
3. [Step 3]
```

3. Use the command:

```
User: /my-command
```

### Hook Customization

Example of adding a new hook:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File was edited: ${file_path}'"
          }
        ]
      }
    ]
  }
}
```

### Permission Adjustment

Adjust permissions according to your project:

```json
{
  "permissions": {
    "allow": [
      "Write(app/**)",      // Allow writing to app directory
      "Bash(yarn *)",       // Allow yarn commands
      "Bash(docker *)"      // Allow docker commands
    ],
    "deny": [
      "Write(*.env)",       // Deny writing to environment files
      "Read(**/*secret*)"   // Deny reading files containing secret
    ]
  }
}
```

## Best Practices

### 1. Security

- Restrict access to files containing environment variables and secrets
- Include `sudo` and destructive commands in the `deny` list
- Regularly review permission settings

### 2. Efficiency

- Define frequently used commands as custom commands
- Use hooks to automate repetitive tasks
- Leverage MCP servers to integrate with external services

### 3. Maintainability

- Regularly update CLAUDE.md and share with the team
- Include clear descriptions for custom commands
- Version control settings.json and track change history

## Troubleshooting

### textlint Not Working

```bash
# Check if textlint is installed
which textlint

# Check if configuration file is in the correct location
ls ~/.claude/.textlintrc.json
```

### Custom Commands Not Recognized

- Verify that the filename ends with `.md`
- Confirm it's placed in the `~/.claude/commands/` directory
- Try restarting Claude Code

### Permission Errors

- Check the `permissions` section in `settings.json`
- Verify that required commands are included in the `allow` list
- Also check the `deny` list for conflicting settings

## Contributing

Contributions to this project are welcome.

1. Fork this repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a pull request

### Contribution Guidelines

- Add clear descriptions for new settings and commands
- Maintain compatibility with existing settings
- Prioritize security considerations

## References

- [Claude Code Official Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [MCP (Model Context Protocol)](https://github.com/anthropics/mcp)
- [textlint](https://textlint.github.io/)

## License

This project is released under the MIT License.

---

When using the settings from this repository, please customize them as needed according to your project and security requirements.
