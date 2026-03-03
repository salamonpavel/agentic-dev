# devflow

A Claude Code plugin that provides role-based agents, skills, and hooks for the software development lifecycle.

## Installation

### Load during a session (development/testing)

```bash
claude --plugin-dir ./devflow
```

### Install for a project

```bash
claude plugin install ./devflow --scope project
```

### Install globally

```bash
claude plugin install ./devflow --scope user
```

---

## Skills

Skills are invokable workflows triggered with `/devflow:<skill-name>`. Each skill orchestrates one or more agents to complete a multi-step task.

---

### `/devflow:feature <description>`

**Full feature development lifecycle.** Takes a feature from idea to tested, reviewed code — without skipping steps.

Runs six phases in sequence, pausing for your confirmation after each:

1. **Requirements** — PM agent clarifies scope, writes user stories and acceptance criteria
2. **Architecture** — Architect agent reads the codebase and produces a concrete implementation blueprint
3. **Implementation** — Developer agent builds the feature following the approved blueprint
4. **Code Review** — Reviewer agent checks all changes; developer agent fixes critical/high issues
5. **Tests** — QA agent writes tests covering happy paths, edge cases, and error conditions
6. **Summary** — Tech-writer agent produces a concise summary of what was built, tested, and decided

Use this when implementing a non-trivial feature and you want structured, agent-driven execution with checkpoints.

```
/devflow:feature Add user authentication with JWT tokens
/devflow:feature Export reports to CSV from the dashboard
```

---

### `/devflow:plan <task>`

**Architecture and implementation plan — no code written.** Delegates to the architect agent, which explores the codebase and produces a file-level blueprint covering:

- Files to create and their purpose
- Files to modify and what changes are needed
- Data flow through the system
- Build sequence — what to implement first and why
- Trade-offs, risks, and alternatives considered

Use this before committing to an approach, or when you want to review the design before any implementation begins.

```
/devflow:plan Migrate the database layer from SQLite to PostgreSQL
/devflow:plan Add rate limiting to the API gateway
```

---

### `/devflow:review [file or directory]`

**Code review of specified files or recent uncommitted changes.** Delegates to the code-reviewer agent, which checks for:

1. Correctness and logic errors
2. Security vulnerabilities (injection, improper auth, exposed credentials)
3. Error handling gaps
4. Performance concerns (N+1 queries, unbounded operations)
5. Reliability issues (race conditions, resource leaks)
6. Maintainability problems

Each finding is reported with severity (`CRITICAL` / `HIGH` / `MEDIUM` / `LOW`), file:line location, and a specific fix suggestion. Ends with a verdict: `APPROVED` or `CHANGES REQUESTED`.

If no argument is given, reviews current uncommitted changes (`git diff`). In non-git directories, asks what to review.

```
/devflow:review src/auth/
/devflow:review src/utils/validators.ts
/devflow:review                          # reviews uncommitted changes
```

---

### `/devflow:test <file>`

**Write comprehensive tests for existing code.** Delegates to the QA agent, which reads the target code and existing tests, then writes tests covering:

- Happy path — expected normal usage
- Edge cases — empty input, boundary values, null handling
- Error cases — invalid input, missing resources, failures

Tests are placed according to the project's existing conventions and written using the existing test framework — no new libraries introduced.

```
/devflow:test src/utils/validators.ts
/devflow:test src/services/UserService.ts
```

---

### `/devflow:refactor <file>`

**Refactor code without changing behavior.** Delegates to the developer agent. Presents a plan before making any changes — you approve before anything is modified.

The refactor targets:
- Duplicated logic that can be extracted
- Overly complex or deeply nested code
- Misleading or unclear names
- Dead code
- Violations of the project's own patterns

Hard constraints: behavior is never changed, scope is limited to what you specified, and no new patterns or abstractions are introduced.

```
/devflow:refactor src/services/PaymentService.ts
/devflow:refactor src/utils/helpers.ts
```

---

### `/devflow:debug <problem>`

**Systematic debugging workflow.** Delegates to the developer agent, which works through the problem step by step:

1. Establishes expected vs. actual behavior and reproducibility
2. Gathers evidence — reads the error, relevant source, recent git changes
3. Forms 2–3 ranked hypotheses with reasoning
4. Investigates the most likely hypothesis before touching any code
5. Implements the minimal fix once root cause is confirmed
6. Verifies the fix and checks for related code with the same bug

Use when you have an error message, unexpected behavior, or a failing test to diagnose.

```
/devflow:debug TypeError: Cannot read property 'id' of undefined at UserService.getUser
/devflow:debug Login form submits but user session is not persisted
```

---

## Agents

Agents are role-based subagents that skills orchestrate automatically. You can also invoke them directly by name in any instruction to Claude.

| Agent | File | When to use |
|-------|------|-------------|
| `product-manager` | `agents/pm.md` | Clarifying requirements, writing user stories, defining acceptance criteria before touching code |
| `architect` | `agents/architect.md` | Designing implementation approach; produces a concrete file-level blueprint grounded in the actual codebase |
| `developer` | `agents/developer.md` | Implementing features; reads existing code first, matches conventions, runs a self-review checklist |
| `code-reviewer` | `agents/reviewer.md` | Reviewing changes for bugs, security issues, and quality; never nitpicks style |
| `qa-engineer` | `agents/qa.md` | Writing tests; covers happy paths, edge cases, and error conditions using the project's existing framework |
| `tech-writer` | `agents/tech-writer.md` | Writing READMEs, API docs, architecture docs, and inline comments for non-obvious logic |

### Triggering agents directly

Skills invoke agents automatically. If you want to call a specific agent outside of a skill workflow, reference it by name in your instruction:

```
Use the architect agent to design an approach for adding webhook support.
Use the tech-writer agent to document the authentication module.
```

---

## Hooks

Hooks run automatically in response to Claude's file operations — no manual invocation needed.

### Lint on save

Runs the appropriate linter every time Claude writes or edits a file.

**Trigger:** `PostToolUse` on `Write`, `Edit`, `MultiEdit`

**Supported linters** (used only if installed):

| Language | Linter |
|----------|--------|
| Python | `ruff` or `flake8` |
| JS/TS | `eslint` |
| Go | `golangci-lint` or `go vet` |
| Rust | `cargo clippy` |
| Shell | `shellcheck` |
| Ruby | `rubocop` |

Hooks report issues but never block Claude from continuing. Install only the linters relevant to your stack.

### Adding format-on-save

The lint hook runs by default. To also format on save, add a second hook entry to `hooks/hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "^(Write|Edit|MultiEdit)$",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/scripts/lint.sh" },
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh" }
        ]
      }
    ]
  }
}
```

**Supported formatters:** `ruff`/`black` (Python), `prettier` (JS/TS/JSON/CSS/HTML/Markdown), `gofmt` (Go), `rustfmt` (Rust), `shfmt` (Shell), `rubocop` (Ruby).

`${CLAUDE_PLUGIN_ROOT}` is an environment variable injected by Claude Code at runtime, pointing to the plugin's installation directory.

Scripts can also be run manually:

```bash
scripts/lint.sh <file>
scripts/format.sh <file>
```

---

## Extending the plugin

**Add a new agent:** create `agents/<name>.md` with `name` and `description` frontmatter.

**Add a new skill:** create `skills/<name>/SKILL.md` with appropriate frontmatter.

**Add a new hook:** add an entry to `hooks/hooks.json` and a corresponding script in `scripts/`.

**Add MCP servers:** create `.mcp.json` at the plugin root and reference it in `plugin.json` via `"mcpServers": "./.mcp.json"`.

---

## License

MIT
