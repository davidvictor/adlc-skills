# OpenAI/Codex Metadata

Each public skill should include:

```text
agents/openai.yaml
```

Required shape:

```yaml
interface:
  display_name: "<Human Name>"
  short_description: "<25-64 char UI description>"
  default_prompt: "Use $adlc-name to <task>."

policy:
  allow_implicit_invocation: true
```

Rules:

- `default_prompt` must mention the skill as `$adlc-name`.
- `short_description` should be human-facing, not a trigger dump.
- Metadata must match the `SKILL.md` purpose.
- Do not add icons unless assets exist.
- Validation should fail if metadata is missing or structurally invalid.
