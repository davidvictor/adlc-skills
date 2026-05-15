# Sprint Materials

Use this reference when the sprint source is a folder, a sparse prompt, or an unfamiliar planning layout.

## Input Forms

Accept either or both:

- `target_folder`: absolute or workspace-relative folder containing sprint materials.
- `instructions`: explicit ordered items, repos, acceptance criteria, and verification commands.

Prompt instructions override folder-derived defaults. Do not infer production, data, billing, or security decisions from folder shape alone.

## Folder Discovery

When given `target_folder`, inspect in this order:

1. Manifests: `adlc-sprint.yaml`, `adlc-sprint.yml`, `sprint-runner.yaml`, `sprint-runner.yml`, `sprint.yaml`, `sprint.yml`, `plan.yaml`, `plan.yml`, `manifest.yaml`, `manifest.yml`, `sprint.json`.
2. Work item indexes: `work-items/README.md`, `prs/README.md`, `pr/README.md`, `changesets/README.md`, `tickets/README.md`.
3. Sprint docs: files matching `*sprint*.md`, `*phase*.md`, `*execution*.md`, `*plan*.md`, and `README.md`.
4. State or handoff docs: `handoff.md`, `agent-handoff.md`, `status.md`, `state.md`, `.adlc-sprint/state.*`, `.sprint-runner/state.*`.

Prefer explicit manifests over inferred Markdown. Prefer ordered tables, dependency lists, and acceptance criteria over narrative prose.

## Manifest Names

`adlc-sprint.yaml` is the canonical ADLC manifest. `sprint-runner.yaml` is a legacy alias for older packages and should remain readable during migration.

The manifest describes work. It must not contain secrets, production credentials, irreversible commands, or provider spend instructions.

## Incomplete Materials

Infer a queue only when order, repos, and verification are clear. If a choice affects repo ownership, destructive behavior, production state, security posture, or paid providers, produce a short normalization report instead of inventing the answer.

## Normalized Item Record

Before execution or handoff, normalize each item to:

- `id`
- `title`
- `status`: `AFK`, `HITL`, `blocked`, or `deferred`
- `spec_source`
- `repos`
- `write_scope`
- `out_of_scope`
- `dependencies`
- `acceptance_criteria`
- `verification`
- `isolation_mode`
- `publication_mode`
- `handoff_target`

Only `AFK` items should be seeded into automated execution. HITL items should become blocked decision tasks or remain visible in the sprint handoff.
