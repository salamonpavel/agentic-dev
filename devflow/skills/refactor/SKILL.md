---
name: refactor
description: Refactor specified code to improve clarity, reduce duplication, or simplify structure — without changing behavior. Always presents a plan before making changes.
argument-hint: <file or code section to refactor>
---

Refactor: $ARGUMENTS

Use the `developer` agent to carry out the following refactoring workflow.

**Process:**

1. Read the code to be refactored.
2. Identify what needs improving:
   - Duplicated logic that could be extracted
   - Overly complex or deeply nested code
   - Misleading or unclear names
   - Dead code
   - Violation of the project's own patterns
3. Present the refactoring plan to the user before making any changes. Describe each change and why.
4. Wait for user approval.
5. Implement the approved refactoring.
6. Run existing tests to confirm behavior is unchanged. If tests aren't available, note this as a risk.

**Hard constraints:**
- Do NOT change behavior — only improve structure.
- Do NOT refactor code outside the scope that was specified.
- Do NOT introduce new patterns or abstractions not already used in the codebase.
- Keep the diff focused and reviewable.
