# agentic-dev

A Claude Code plugin marketplace. Each subdirectory is a standalone plugin.

## Plugins

| Plugin | Description |
|--------|-------------|
| [devflow](./devflow/) | Development lifecycle plugin with role-based agents, skills, and automation hooks |

## Installation

### 1. Add the marketplace

```bash
claude plugin marketplace add salamonpavel/agentic-dev
```

### 2. Install a plugin

```bash
claude plugin install devflow@agentic-dev --scope user
```

Use `--scope project` instead to install for a single project only.

## License

MIT
