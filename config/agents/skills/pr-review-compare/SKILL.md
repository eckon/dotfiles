---
name: pr-review-compare
description: Runs a PR review with both the pr-review and open-code-review-delegate setups in parallel, merges the findings into one view and compares both. Use when the user asks to review a PR and compare both setups.
---

# PR review compare

## Workflow

1. Start two `general` subagents in parallel, both on the current branch against the base branch:
   - A: "Load the `pr-review` skill and follow it. Return the full review as markdown."
   - B: "Load the `open-code-review-delegate` skill and review the branch in range mode against the base branch. Return the full review as markdown."
   - Tell both to only review, not to change files.
2. Wait for both results. Do not review the code yourself, except to verify disputed findings.
3. Merge the findings:
   - match findings that mean the same issue, even with different wording or line ranges
   - verify findings found by only one side by reading the code; mark wrong ones as rejected
4. Answer in this format.

## Output

### Merged review

One list grouped by severity (Critical, Warning, Suggestion). Each item: title, `file:line`, short reason, and a tag `[both]`, `[manual]` or `[ocr]`.
Add a short "Rejected" list for findings that turned out wrong.

### Comparison

- Table: finding | manual | ocr (✅ / ❌ / ⚠️ partial or other severity)
- Only in manual / only in ocr: one line each, with whether it matters
- Severity or advice conflicts
- Verdict: which setup did better here and why (coverage, accuracy, actionability, noise), in 2-3 sentences
