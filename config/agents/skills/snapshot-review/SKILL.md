---
name: snapshot-review
description: Validates snapshot/golden-file test diffs while reviewing a PR.
---

# Snapshot Review

**Condition**

- Code to validate is provided "externally" through another skill, the user or similar
- **DO NOT** try to figure out what to validate, if its not provided
  - If nothing was provided state so and **stop**
- We expect the snapshot files to be updated, no need to rerun tests etc. in here

**Goal**

- Validate the snapshot against what the **user/requirement** expects, not just that it matches what the code happens to produce
  - "the diff is internally consistent with the code change" is NOT a pass - code can faithfully implement wrong logic and still produce a self-consistent snapshot
  - for every changed value, ask "is this the value a correct implementation of the stated intent would produce?", not just "does this match the diff of the implementation?"
- Base it on the user's explanation of intent/requirements first, the code changes second

## Workflow

1. Identify used snapshot tool
2. List/Get changed snapshot files
3. Read the **diff** (not the full file) for every single changed snapshot file individually - no sampling, no skipping, no inferring from `--stat`/size/shape alone
   - even files that look identical in size/shape to an already-checked one must still be diffed and read
   - the diff is sufficient for review; only open the full file when a diff hunk is ambiguous without surrounding context (e.g. to check ordering/position of a change)
   - to triage cheaply before reading each diff in full, grep the combined diffs for aggregate patterns (e.g. count added vs. removed occurrences of each value)
     to catch obvious mismatches first, then read the individual diffs to pinpoint and confirm
   - group the findings accordingly:
     - **Run-to-run noise** (renumbered placeholder, reordered but same content) - ignore
     - **Expected new content** (matches the *stated intent*, not just the code's own logic) - confirm values/scope are correct against the requirement
     - **Unexplained change** (anything else, including content that matches the code but not the intent) - flag it, this is a regression/logic-error candidate
4. Cross-check the corresponding test file's assertions/sanity-checks
5. Spot-check edge cases explicitly
6. Verify a 1:1 match between the list from step 2 and the files actually diffed in step 3 - if any file was not read, go back and read it before reporting results

## Red flags

- New content appears in the wrong place/scope.
- Data got removed that should have been the same.
- Duplicate entries where dedup was expected.
- Assertions unchanged despite the snapshot growing/shrinking.
- Ordering changed beyond what an intentional sort-key change explains.

## Output

**State plainly**

- Did anything old break, yes/no, with the specific hunk as evidence
- List every changed file and confirm all of them were individually diffed and checked - "sampled" or "inferred from stat" is not acceptable
- Don't pad with reassurance if evidence is thin, say so.
