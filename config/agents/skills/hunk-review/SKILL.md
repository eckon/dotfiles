---
name: hunk-review
description: Reviews pull/merge request changes by using hunk. Use when the user asks to review a PR, MR, or code changes via hunk.
---

# PR/MR Review

Do a code review with the tool `hunk` against the current live hunk session.

## Workflow

1. Load the Hunk skill and use it for this review
2. Run `hunk skill path` to get the skill path
3. Continue with the hunk skill accordingly

## Expected Output

- keep comments short
- prefix the comments with severity
  - **Critical**: Bugs, security issues, data loss risks
  - **Warning**: Logic issues, potential edge cases, performance concerns
  - **Suggestion**: Style, readability, minor improvements
- do not include "good job" comments, just warnings, errors, improvements, etc.
