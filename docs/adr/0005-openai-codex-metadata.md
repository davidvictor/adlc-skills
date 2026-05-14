# Per-Skill OpenAI/Codex Metadata

Status: Accepted

## Context

ADLC should remain useful across agents instead of becoming only a Claude plugin bundle. The repo already has `.claude-plugin/plugin.json`, but public skill use also benefits from per-skill UI metadata.

## Decision

Every public ADLC skill includes:

```text
agents/openai.yaml
```

Required fields:

- `interface.display_name`
- `interface.short_description`
- `interface.default_prompt`
- `policy.allow_implicit_invocation`

Validation fails if metadata is missing, structurally invalid, or disconnected from the skill name.

## Consequences

Each skill remains self-contained for cross-agent packaging. Future metadata fields can be added without changing the public skill body.
