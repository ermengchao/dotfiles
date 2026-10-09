# AGENTS.md

## CLI Conventions

While the user prefers fish, you can still use zsh (if available) or bash when executing internal commands.

However, when instructing the user or providing copyable shell commands, use fish-compatible syntax. For example:

```fish
set -x NODE_ENV development
set -x PATH ./node_modules/.bin $PATH
command1; and command2
command1; or command2
```

Avoid giving the user syntax that only works in bash or zsh, such as:

```bash
export NODE_ENV=development
command1 && command2
```

## Tooling preferences

Use the following tools by default:


| Task | Use | Avoid |
|---|---|---|
| JS runtime / package manager | `bun` | `npm`, `pnpm`, `yarn` |
| Run JS packages | `bunx` | `npx` |
| Find files | `fd` | `find` |
| Search text | `rg` | `grep` |


When a preferred tool is unavailable or incompatible with the project, use the necessary alternative and briefly explain why.

## OrbStack virtual machines

When accessing the Arch virtual machine managed by OrbStack:

- Prefer `ssh orb '<command>'` for non-interactive diagnostics and `orb` for an interactive shell.
- Commands using `orb`, `orbctl`, or `ssh orb` may require access outside the Codex sandbox because they communicate with OrbStack Helper through local IPC, a proxy command, and local network forwarding.
- If an OrbStack command hangs, reports `Operation not permitted`, or reports `timed out waiting for VM to start` inside the sandbox:
  1. Stop the hanging command.
  2. Retry the same read-only command with escalated sandbox permissions.
  3. Do not conclude that OrbStack or the guest VM is unavailable unless the escalated command also fails.
- Use a harmless probe such as:

  ```fish
  orb -m arch -u chao uname -a
  ```

  or:

  ```fish
  ssh -o BatchMode=yes -o ConnectTimeout=10 orb true
  ```

- `ssh orb` is an OrbStack SSH alias. It may use `127.0.0.1`, a forwarded port, `ProxyCommand`, and OrbStack's private SSH key. Do not replace it with a direct connection to the guest IP on port 22 unless specifically testing the guest's own SSH server.
- A failure connecting directly to `<guest-ip>:22` does not prove that `ssh orb` is unavailable.
- Do not stop, restart, or otherwise modify OrbStack or its virtual machines based only on a failure observed inside the Codex sandbox.
- Before restarting a VM, verify the failure outside the sandbox and obtain the user's approval if the restart may interrupt running processes.
- When reporting a connection problem, explicitly distinguish among:
  - Codex sandbox restrictions;
  - OrbStack Helper or proxy failures;
  - guest-agent failures;
  - the guest operating system's own network configuration.

## Tools

### graphify
- **graphify** — create, update, and query knowledge graphs.
When the user explicitly invokes `/graphify`, read the currently available `graphify` skill and follow its instructions using the tools available in the current environment.
