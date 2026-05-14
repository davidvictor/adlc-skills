---
name: adlc-audit
description: Review a diff against both documented standards and the originating spec or PRD. Use when the user wants to review a PR, branch, work-in-progress diff, implementation against a plan, or changes since a fixed point.
---

# ADLC Audit

Audit changes along two separate axes:

- **Standards**: does the diff follow the repo's documented engineering rules?
- **Spec**: does the diff implement what the plan, PRD, issue, or prompt asked for?

Keep the axes separate so one does not hide the other.

## Process

1. Pin the comparison point. If missing, ask what to compare against.
2. Capture:
   - `git diff <fixed-point>...HEAD`
   - `git log <fixed-point>..HEAD --oneline`
3. Find the spec source:
   - issue or PRD references in commits
   - path supplied by the user
   - PRD/spec files under `docs/`, `specs/`, `plans/`, or `.scratch/`
   - if absent, say no spec source was found
4. Find standards sources:
   - `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`
   - `CONTEXT.md`, `CONTEXT-MAP.md`
   - `docs/adr/`
   - style or tooling config
5. Review the diff.

## Output

Lead with findings, ordered by severity.

For each finding include:

- axis: Standards or Spec
- severity
- file or behavior affected
- evidence
- why it matters
- suggested fix or decision needed

Then include:

- open questions
- test gaps
- what aligned well

If there are no issues, say so clearly and name residual risk.
