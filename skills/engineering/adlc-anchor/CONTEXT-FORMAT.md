# CONTEXT.md Format

`CONTEXT.md` is a compact glossary and relationship map for one repo.

## Template

```markdown
# <Context Name>

One or two sentences describing what this context is and why it exists.

## Language

**Term**:
One-sentence definition of what the term is.
_Avoid_: ambiguous synonym, stale name

## Relationships

- A **Term** owns many **Other Terms**
- A **Workflow** produces exactly one **Artifact**

## Example Dialogue

> **Developer:** "When a **Term** changes, should the **Artifact** update immediately?"
> **Domain expert:** "No. The **Artifact** updates only after **Workflow** completes."

## Flagged Ambiguities

- "account" was used to mean both **Customer** and **User**. Resolved: these are distinct terms.
```

## Rules

- Be opinionated. Pick canonical terms.
- Keep definitions to one sentence.
- Define what the thing is, not every behavior it has.
- Show relationships and cardinality when obvious.
- Record ambiguity resolutions.
- Do not include implementation details, file paths, tickets, or PRD content.
- Do not add generic software terms unless this repo gives them a special meaning.

## Multi-Context Repos

If a repo needs multiple context files, create `CONTEXT-MAP.md` at the root:

```markdown
# Context Map

## Contexts

- [Billing](./src/billing/CONTEXT.md) — invoices and payment state.
- [Identity](./src/identity/CONTEXT.md) — users, sessions, and access.

## Relationships

- **Identity -> Billing**: Billing references users by `UserId`.
```
