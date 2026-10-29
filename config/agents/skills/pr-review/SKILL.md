---
name: pr-review
description: Reviews pull/merge request changes by analyzing the local git diff against the base branch. Use when the user asks to review a PR, MR, or code changes.
---

# PR/MR review

Review the changes of the current branch against the base branch. Check that both branches are up to date.

## Workflow

1. Find the base branch with `git remote show origin | grep 'HEAD branch'`
2. Read the intent of the changes with `git log --oneline <base-branch>..HEAD`
3. Get an overview with `git diff <base-branch>...HEAD --stat`
4. Group the changed files by domain (see below) and skip generated files like lock files
5. Review the changes
   - if the user names domains, only review those
   - for a small diff or a single domain, review directly with `git diff <base-branch>...HEAD -- <paths>`
   - for multiple domains, start one subagent per domain with the base branch, its files and its focus
   - for a very large diff, ask the user which domains to review
6. Check for problems between domains, e.g. an API change without a consumer update
7. Read related files when the diff alone is not enough

## Domains

- Backend, focus on API changes, auth, data access, error handling and concurrency
- Frontend, focus on state, rendering, API usage, accessibility and translations
- Infrastructure (CI, containers, k8s, IaC, scripts), focus on secrets, destructive changes and safe rollouts
- Data (migrations, schemas, events, API specs), focus on backwards compatibility and data loss
- Tests, focus on coverage of changed logic and flaky patterns

## Output format

- Use a numbered list
  - the header of each item has the domain and a short description of at most 10 words
- Each item has sub bullet points with
  - the file path and line number
  - a short description of the problem and why it matters, split into several bullet points instead of long sentences
- Group the items by severity
  - Critical for bugs, security issues and data loss risks
  - Warning for logic issues, edge cases and performance concerns
  - Suggestion for style, readability and minor improvements
