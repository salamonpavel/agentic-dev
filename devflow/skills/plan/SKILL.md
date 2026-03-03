---
name: plan
description: Create a detailed implementation plan for a feature or task without writing any code. Use when the user wants to understand the approach before committing to implementation.
argument-hint: <feature or task to plan>
---

Create an implementation plan for: $ARGUMENTS

Use the `architect` agent to:
1. Explore the relevant parts of the codebase
2. Design the implementation approach
3. Produce a concrete blueprint

The plan should cover:
- Files to create and their purpose
- Files to modify and what changes are needed
- Key design decisions and why they were made
- Build sequence — what to implement first and why
- Potential risks or tricky parts

Do not write any implementation code. The goal is a plan the user can review and approve before any code is written.

At the end, ask: "Does this plan look right, or would you like to adjust the approach?"
