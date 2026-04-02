---
name: pr-review
description: Reviews pull/merge request changes by analyzing the local git diff against the base branch. Use when the user asks to review a PR, MR, or code changes.
---

# PR/MR Review

Review the current branch's changes against the base branch. It is expected that the base branch is up to date.

## Workflow

1. **Identify the base branch**: Run `git remote show origin | grep 'HEAD branch'`
2. **DO NOT run irrelevant commands on initial data collection**
   - `git branch --show-current` can be ignored
3. **Get commit history**: Run `git log --oneline <base-branch>..HEAD` to understand the intent behind each commit
4. **Get diff stats**: Run `git diff <base-branch>...HEAD --stat` to see a general overview of changed files
5. **Get the diff**: Run `git diff <base-branch>...HEAD` to see all changes introduced by the current branch
6. **Handle large diffs**: If `--stat` shows more than 50 changed files, review in batches
   - prioritize files with the most changes from `--stat`
   - use the Task tool to review groups of related files separately
   - skip generated files (lock files, build artifacts, etc.)
7. **Analyze the changes**: Read relevant files for full context when needed

## Output Format

Provide a structured review with:

- use a numbered list
  - header of the list item is a short description maximum 10 words
- sub bullet points include
  - a reference to the file path and line number
  - a more detailed, but still short, description of the problem and reasons
    - instead of writing long sentences, split these into multiple bullet points as well
- split the findings into groups of severity
  - **Critical**: Bugs, security issues, data loss risks
  - **Warning**: Logic issues, potential edge cases, performance concerns
  - **Suggestion**: Style, readability, minor improvements
