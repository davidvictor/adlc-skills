---
id: adlc-adr-0002-framework-foundation
type: adr
status: accepted
owner: ADLC
depends_on: [adlc-doc-factory-parity-gap-plan]
---

# ADR 0002: ADLC Ports The Lean Factory Foundation

Status: accepted

## Context

ADR 0001 intentionally kept ADLC small while the AI Factory concepts were renamed and adapted. A follow-up parity audit showed that several omissions were structural rather than optional: CLI entrypoint, managed state, artifact audit, gate schema, standalone lifecycle skills, runtime targets, MCP setup, and extensions.

## Decision

ADLC now includes a lean factory foundation:

- `bin/adlc.js` is the local CLI entrypoint.
- `adlc-gate-result` is the standard parseable gate block.
- `audit-artifacts` validates markdown artifact IDs and relations.
- managed runtime state tracks packaged skills and agents by hash.
- runtime installs support `codex-home`, `codex-project`, `claude-project`, and `universal-project`.
- `codex-project` installs and tracks the managed `.codex/config.toml` baseline while ignoring ADLC MCP blocks for drift checks.
- MCP auto-config supports known local templates.
- local extensions install through `extension.json` and project-local registry state, with custom skills, replacements, injections, agent files, and MCP cleanup.
- roadmap, architecture, rules, rules-check, security-checklist, docs, QA, reference, and loop are standalone ADLC lifecycle skills.
- workstreams provide durable epic step cards and Codex/Hermes handoff contracts without adding a Hermes runner.

## Deliberate Limits

ADLC still does not port the entire AI Factory distribution model:

- no public NPM package yet
- no remote extension fetching or version marketplace
- no dynamic extension CLI command loading or extension-defined runtime registration yet
- no broad upstream runtime matrix
- no Docker, CI, build-automation, broad best-practices, or skill-generator command surface

Those features should be added only after real ADLC usage creates a concrete need.

## Consequences

ADLC is now a real framework foundation, not just a renamed skill set. It remains private, lean, and tailored to David's workflow.
