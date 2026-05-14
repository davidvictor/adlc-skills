# ADR Format

ADRs live in `docs/adr/` and use sequential filenames:

```text
0001-short-slug.md
0002-short-slug.md
```

## Minimal Template

```markdown
# <Short Decision Title>

We decided <decision> because <reason>. The key trade-off was <trade-off>.
```

That is enough for most ADRs.

## Optional Sections

Add only when they help:

- `Status: proposed | accepted | deprecated | superseded`
- Considered options
- Consequences
- Links to related PRDs, issues, or code

## ADR Test

Create an ADR only when the decision is:

- hard to reverse
- surprising without context
- the result of a real trade-off

If one of those is missing, do not create an ADR.
