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

## Tools

### graphify
- **graphify** — create, update, and query knowledge graphs.
When the user explicitly invokes `/graphify`, read the currently available `graphify` skill and follow its instructions using the tools available in the current environment.
