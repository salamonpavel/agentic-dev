---
name: debug
description: Systematically debug an error, unexpected behavior, or failing test. Use when there's a problem to diagnose — not just when something needs to be built.
argument-hint: <error message or description of the problem>
---

Debug this problem: $ARGUMENTS

Use the `developer` agent to work through this process systematically:

## 1. Understand the Problem
Before touching any code, establish:
- What is the **expected** behavior?
- What is the **actual** behavior?
- Is this reproducible? Always, sometimes, or under specific conditions?
- When did it start? After a recent change?

## 2. Gather Evidence
- Read the error message and full stack trace carefully
- Read the relevant source files
- Check recent changes: `git log --oneline -20` and `git diff`
- Look at configuration and environment that could affect behavior

## 3. Form Hypotheses
List 2–3 specific, testable hypotheses about the root cause.
Rank them by likelihood. Explain your reasoning.

## 4. Investigate
Test the most likely hypothesis first:
- Add targeted logging or debugging to verify/disprove
- Trace the execution path
- Check edge cases at the point of failure

Do not change production code until the root cause is confirmed.

## 5. Fix
Once the root cause is confirmed:
- Implement the minimal fix that addresses it
- Explain clearly why this fix resolves the root cause

## 6. Verify and Prevent
- Confirm the fix resolves the original problem
- Check for related code that might have the same bug
- Add a regression test if one doesn't exist
