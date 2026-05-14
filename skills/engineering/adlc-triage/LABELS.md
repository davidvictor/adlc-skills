# Category And State Mapping

ADLC uses canonical category and state names internally. Trackers may use different label or workflow strings.

## Local Mapping Template

```markdown
# ADLC Tracker Labels

## Categories

- bug:
- enhancement:
- chore:
- research:
- design:
- debt:

## Readiness States

- needs-shaping:
- needs-info:
- ready-for-agent:
- ready-for-human:
- blocked:
- deferred:
- wontfix:

## Rules

- Each item should have one category and one readiness state.
- If tracker workflow state and labels conflict, stop and ask.
- Human-owned states must name the human decision or access needed.
```

## Default Local Markdown

Represent category and state in the issue draft body:

```markdown
## Category

enhancement

## State

ready-for-agent
```

## GitHub

Prefer labels:

- `category:<category>`
- `state:<state>`

If the repo already has labels, map to existing labels instead of creating duplicates.

## Linear

Use Linear workflow state for readiness when the team has matching states. Otherwise use labels for readiness and keep the workflow state unchanged unless the operating contract says otherwise.
