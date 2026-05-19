---
id: adlc-project-rules
type: rules
status: active
owner: ADLC
---

# Rules

## Public Surface

- Public skill names must be `adlc` or `adlc-*`.
- Keep the command surface small; prefer modes or references before adding a new top-level skill.
- Do not restore old `aif*`, Hermes phase-skill, or broad tracker abstractions.
- Keep optional infrastructure surfaces out of core until real usage proves they deserve ADLC-native commands.

## Artifact Ownership

- Target-project runtime artifacts default to `.adlc/`.
- `adlc-plan` owns plans; `adlc-improve` may refine them.
- `adlc-workstream` owns epic workstreams, step cards, Kanban state, and Codex/Hermes handoff exports.
- `adlc-implement` owns selected implementation changes.
- Verification, review, rules, security, docs, and best-practices sidecars are read-only unless the user explicitly promotes them to a fix task.

## Implementation Rules

- Preserve unrelated user work.
- Use native Codex agents for independent bounded work and read-only sidecars.
- Keep long-running state in files, not conversation memory.
- Prefer evidence from live repo files, CLI output, docs, and committed decisions over assumptions.

## Validation

Before claiming package consistency, run:

```bash
node bin/adlc.js validate
bash scripts/test-adlc-cli.sh
bash scripts/test-adlc-skill-fixtures.sh
node bin/adlc.js audit-artifacts --strict docs README.md AGENTS.md
```
