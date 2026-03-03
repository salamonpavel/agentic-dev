---
name: feature
description: Full feature development lifecycle. Orchestrates PM, architect, developer, reviewer, and QA agents to take a feature from requirements through to tested, reviewed code. Use when implementing a non-trivial new feature.
argument-hint: <feature description>
---

Implement the following feature end-to-end: $ARGUMENTS

Walk through these phases in order. After each phase, present the output to the user and wait for explicit confirmation before proceeding to the next.

---

## Phase 1: Requirements

Use the `product-manager` agent to:
- Clarify and restate the feature requirements
- Define user stories and acceptance criteria
- Identify scope boundaries and open questions

**Checkpoint**: Present the feature specification and ask the user: "Does this capture the requirements correctly? Shall I proceed to architecture?"

---

## Phase 2: Architecture

Use the `architect` agent to:
- Explore the existing codebase
- Design the implementation approach
- Produce a concrete blueprint (files to create/modify, data flow, build sequence)

**Checkpoint**: Present the blueprint and ask: "Does this approach look right? Shall I proceed with implementation?"

---

## Phase 3: Implementation

Use the `developer` agent to:
- Implement the feature according to the approved blueprint
- Follow existing code conventions
- Self-review before finishing

**Checkpoint**: Present what was implemented and ask: "Implementation complete. Shall I proceed with code review?"

---

## Phase 4: Code Review

Use the `code-reviewer` agent to:
- Review all changes made in Phase 3
- Report issues by severity

If CRITICAL or HIGH issues are found, use the `developer` agent to fix them before continuing.

**Checkpoint**: Present the review findings and ask: "Review complete. Shall I proceed with writing tests?"

---

## Phase 5: Tests

Use the `qa-engineer` agent to:
- Write tests covering happy paths, edge cases, and error conditions
- Match the project's existing test framework and patterns

**Checkpoint**: Present the tests written and ask: "Tests complete. Shall I produce the final summary?"

---

## Phase 6: Summary

Use the `tech-writer` agent to produce a concise summary of:
- What was built
- What tests were written
- Any notable decisions, trade-offs, or things the user should be aware of

**Checkpoint**: Present the summary and ask: "Feature development complete. Is there anything you'd like to revisit or adjust?"
