---
name: kill-dev-process
description: Kill orphaned dev servers, browsers, and port-hogging processes spawned during development. Use when ports are occupied, too many node/browser processes are running, or you want a fresh start.
---

# Dev Environment Cleanup

Safely clean up processes accumulated during development (dev servers, browsers, node, etc.).

Usage: `/kill-dev-process`
Usage: `/kill-dev-process $MODE`

`$ARGUMENTS` to specify mode:
- `ports` — Only processes occupying listening ports
- `browsers` — Only browser processes
- `all` — Process all categories at once
- No argument — Interactive selection

## Execution Steps

### Step 1: Investigate the Current State

Run the following commands **in parallel** to assess the current situation:

```bash
# List listening TCP ports (macOS)
lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | grep -v "^COMMAND"
```

```bash
# Dev-related node processes
ps aux | grep -E '[n]ode|[t]sx|[v]ite|[n]ext|[n]uxt|[e]sbuild|[t]sc |[b]un ' | grep -v 'grep'
```

```bash
# Browser processes (including those from Playwright/Chrome DevTools MCP)
ps aux | grep -E '[C]hromium|[c]hrome|[C]hrome Helper|[p]laywright' | grep -v 'grep'
```

### Step 2: Classify and Display Results

Classify detected processes into the following categories and display in **table format**:

| Category | Criteria |
|----------|----------|
| Dev Servers | Processes listening on ports 3000-9999 via node/bun/deno |
| Browsers | Chromium, Chrome, Playwright-related processes |
| Build Tools | Residual esbuild, tsc, webpack, turbopack, etc. |
| Other | Anything else requiring user confirmation |

Display format example:
```
## Detected Processes

### Dev Servers (3 items)
PID    PORT   COMMAND              STARTED
12345  3000   node next-server     10:30
12346  5173   node vite            11:45
12347  8080   node express         09:00

### Browsers (5 items)
PID    COMMAND                      MEM
23456  Chromium --headless           120M
23457  Chrome Helper (Renderer)       80M
...
```

### Step 3: Safety Check

**Processes that must NEVER be killed:**
- System processes (PID < 100, root-owned system daemons)
- Databases (postgres, mysql, redis, mongo)
- Docker / containerd
- SSH / sshd
- IDE itself (VSCode, Cursor) — Chrome helpers ARE eligible targets
- Long-running processes that appear to be intentionally started by the user

If any of the above are detected, exclude them and display a notice about the exclusion.

### Step 4: Confirm with the User

Unless the mode is `all`, use `AskUserQuestion` to get confirmation:

- Allow the user to select "Kill / Skip" for each category
- Support keeping specific PIDs alive

### Step 5: Terminate Processes

1. First attempt graceful shutdown with `kill -TERM <PID>`
2. Wait 1 second and check survival: `kill -0 <PID> 2>/dev/null`
3. If still alive, force kill with `kill -9 <PID>`
4. Display termination results

```bash
# Example: graceful shutdown
kill -TERM 12345 12346 12347

# Check survival after 1 second
sleep 1
for pid in 12345 12346 12347; do
  kill -0 $pid 2>/dev/null && echo "PID $pid still alive, force killing..." && kill -9 $pid
done
```

### Step 6: Result Report

Display a summary of the cleanup results:

```
## Cleanup Complete

- Terminated: 8 processes
- Freed ports: 3000, 5173, 8080
- Skipped: 2 (postgres, redis)
- Failed: 0
```

## Notes

- Assumes macOS environment (`lsof` flags, etc.)
- Always get user confirmation before killing processes (including `all` mode)
- Only use actual PIDs obtained from investigation results for `kill` commands
- Investigation and termination are separate steps — never pipe them together (prevents accidental kills)
