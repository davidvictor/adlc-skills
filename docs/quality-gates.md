---
id: adlc-doc-quality-gates
type: guide
status: active
owner: ADLC
---

# Quality Gates

ADLC gates produce normal human-readable findings and finish with one parseable `adlc-gate-result` block.

Supported gates:

- `verify`
- `review`
- `rules`
- `security`

The schema is defined in [Gate Result Schema](./gate-result-schema.md).

## Gate Order

Default closeout order:

1. `adlc-verify`
2. optional `adlc-rules-check`
3. optional `adlc-security-checklist`
4. optional `adlc-docs`
5. optional `adlc-qa`
6. `adlc-review`
7. `adlc-commit`

## Blocking

A gate blocks progress when `blocking: true` or when `status: "fail"` with one or more blockers. Non-blocking warnings should stay in prose and keep `blockers: []`.

## Parser Rule

Automation should parse only the final `adlc-gate-result` fenced block. Do not scrape prose.
