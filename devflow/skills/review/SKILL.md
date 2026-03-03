---
name: review
description: Review code changes for bugs, security issues, and code quality. Use before committing or merging. If no argument is given, reviews recent uncommitted changes.
argument-hint: [file, directory, or git ref to review]
---

Use the `code-reviewer` agent to conduct the review.

Determine what to review:
- If an argument was provided, review: $ARGUMENTS
- If no argument was provided and the directory is a git repository, check for uncommitted changes with `git diff` and `git diff --cached`; if there are no uncommitted changes, ask the user what to review
- If the directory is not a git repository, ask the user to specify what to review

Focus the review on:
1. Correctness and logic errors
2. Security vulnerabilities
3. Error handling gaps
4. Performance concerns
5. Code quality and maintainability

Report findings with severity (CRITICAL / HIGH / MEDIUM / LOW), file:line location, and a specific fix suggestion for each issue.

End with a clear verdict: APPROVED or CHANGES REQUESTED.
