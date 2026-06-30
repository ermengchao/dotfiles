# AGENTS.md

## CLI Conventions

Prefer commands that work in `fish`. Use fish-compatible syntax:

```fish
set -x NODE_ENV development
set -x PATH ./node_modules/.bin $PATH
command1; and command2
command1; or command2
```

When invoking `fish` inside the Codex sandbox, avoid writing to the real
`~/.config/fish` by giving fish a temporary writable config directory:

```fish
env XDG_CONFIG_HOME=/private/tmp/codex-fish-config fish --no-config -c 'set -e XDG_CONFIG_HOME; your-command'
```

This lets fish write its own temporary `fish_variables`, while preventing the
actual command from inheriting the temporary `XDG_CONFIG_HOME`. If the command
being run is itself `fish`, keep `XDG_CONFIG_HOME` set for that nested fish
process.

## Tooling preferences

Use the following tools by default:


| Task | Use | Avoid |
|---|---|---|
| Shell | `fish` | `zsh`, `bash` |
| JS runtime / package manager | `bun` | `npm`, `pnpm`, `yarn` |
| Run JS packages | `bunx` | `npx` |
| Find files | `fd` | `find` |
| Search text | `rg` | `grep` |


When a preferred tool is unavailable or incompatible with the project, use the necessary alternative and briefly explain why.

## Tools

### graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
