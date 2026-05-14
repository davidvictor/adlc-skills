# Tracker Adapters

ADLC is local-first. External trackers mirror or publish local-ready artifacts; they do not replace the repo contract.

## Local Markdown

Use when:

- the repo is private, experimental, solo-operated, or not connected to a tracker
- the user wants review before publishing externally

Conventions:

- PRDs: `docs/adlc/prds/<slug>.md`
- issue drafts: `.scratch/adlc-issues/<slug>/<nn-title>.md`
- triage notes: `.scratch/adlc-triage/<slug>.md`
- handoffs: `.scratch/adlc-handoffs/<slug>.md`
- out-of-scope memory: `.out-of-scope/<concept>.md`

When a skill says "publish", local mode means "write the Markdown file and return the path."

## GitHub

Use when:

- the repo remote is GitHub and issues are enabled
- the user wants tracker-visible issues or PRD issues

Conventions:

- keep the local draft path in the issue body
- use labels mapped from ADLC category and readiness state
- publish dependency order first when creating multiple issues
- never close or mutate parent issues unless explicitly asked

Expected command shape:

```bash
gh issue create --title "<title>" --body-file "<local-draft.md>" --label "<label>"
```

If `gh` is unavailable or unauthenticated, keep the local draft and report the blocked publish step.

## Linear

Use when:

- the project tracks product work in Linear
- the user supplies the team/project context or connector/tooling is available

Conventions:

- local draft remains the source artifact
- Linear issue body includes source artifact path or repo link
- ADLC category maps to Linear label
- ADLC readiness state maps to label or workflow state according to `docs/adlc/tracker-labels.md`

If the Linear project/team is ambiguous, ask one question before publishing. Do not guess the team.

## Other Trackers

Record the user's workflow in `docs/adlc/operating-contract.md`. Preserve:

- where work is created
- how category and state are represented
- how local drafts link to tracker items
- which actions require human confirmation
