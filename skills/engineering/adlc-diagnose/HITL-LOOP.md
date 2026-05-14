# Human-In-The-Loop Reproduction

Use only when the failure cannot be driven by tests, CLI, HTTP, browser automation, or fixture replay.

## Shape

Write a small checklist or script that:

- gives the human one action at a time
- records exact observed output
- captures timestamps, IDs, screenshots, or logs
- ends with a parseable summary

## Rules

- Do not ask the human to "try it again" without changing the signal.
- Keep the loop repeatable.
- Convert the HITL loop into automation if a stable seam appears.

## Minimal Template

```markdown
# HITL Repro: <Bug>

1. Open:
2. Log in as:
3. Perform:
4. Expected:
5. Actual:
6. Capture:

Result:
```
