---
name: test
description: Write comprehensive tests for a file, module, or function. Use when adding test coverage to existing or new code.
argument-hint: <file or module to test>
---

Write tests for: $ARGUMENTS

Use the `qa-engineer` agent to:
1. Read the code to be tested
2. Read existing tests in the project to match the testing framework and conventions
3. Write tests covering:
   - Happy path (expected normal usage)
   - Edge cases (empty input, boundary values, etc.)
   - Error cases (invalid input, failures, missing data)
4. Place tests according to the project's existing test file conventions

Do not change the implementation code. Focus only on writing tests.

After writing tests, briefly describe what each test group covers and flag any code that is difficult to test and why.
