# ADLC Skill Expansion Pass 2 Spec

Status: implemented.

Baseline commit: `6a542f7` (`Expand ADLC lifecycle skills`)

## Goal

Bring ADLC from workflow-complete and operationally usable to deeply useful, public-quality, and hard to misuse.

The first pass added the full lifecycle surface. This pass should close the deferred depth gaps: examples, golden outputs, cross-agent packaging, richer references, validation coverage, adapter conventions, and per-skill acceptance tests.

## Success Criteria

Pass 2 is complete when:

- every skill has enough detail to guide a capable agent without bloating `SKILL.md`
- task-critical references exist for each skill whose workflow can fail from ambiguity
- central examples/golden outputs show the intended ADLC flavor across the full lifecycle
- validation covers manifests, links, frontmatter, scripts, example references, and metadata expectations
- cross-agent metadata policy is implemented or explicitly deferred with an ADR
- install/use smoke checks prove the repo behaves as a skill collection
- README explains how to use ADLC as a lifecycle, not just as a list of skills
- no known lifecycle phase has only generic guidance where a concrete artifact contract is needed

## Resolved Decisions

- Examples strategy: hybrid.
- End-to-end scenario: lightweight SaaS operations app.
- Example depth: compact but real.
- Cross-agent metadata: generate per-skill `agents/openai.yaml`.
- First-class adapters: Local Markdown, GitHub, Linear.
- Validation: structural only.
- Public-release target: release-ready branch after review.
- Priority skills: setup, triage, build, diagnose, interface, polish, release, skill-maintain.
- No gaps means no operational gaps for a new public user.

## Completed Workstreams

### 1. Central Examples And Golden Outputs

Create a central examples area, likely:

```text
docs/examples/
|-- lifecycle-thread.md
|-- operating-contract.example.md
|-- agent-brief.example.md
|-- prd.example.md
|-- issue-slice.example.md
|-- diagnosis-report.example.md
|-- frontend-polish-report.example.md
|-- release-plan.example.md
`-- handoff.example.md
```

Purpose:

- encode ADLC's tone and specificity
- show what "ready-for-agent" really means
- prevent future agents from producing thin artifacts
- make validation and community review easier

Resolution: use one SaaS operations lifecycle thread plus focused golden outputs.

### 2. Cross-Agent Metadata

Current repo has `.claude-plugin/plugin.json`. Pass 2 should decide and implement the next metadata layer.

Possible outputs:

- `agents/openai.yaml` per skill
- generated metadata index under `docs/` or root
- a script that checks descriptions against metadata
- ADR documenting why a metadata format is or is not included

Resolution: every public skill has per-skill OpenAI/Codex metadata.

### 3. Skill-Specific Depth Audit

Audit each skill for missing concrete contracts.

Likely additions:

- `adlc-setup`: concrete tracker adapter docs for local, GitHub, Linear, Jira/other
- `adlc-triage`: out-of-scope record template and label/status mapping template
- `adlc-build`: red/green/refactor reference and UI evidence examples
- `adlc-diagnose`: HITL loop template and instrumentation cleanup checklist
- `adlc-interface`: visual direction reference and responsive state checklist
- `adlc-polish`: before/after report template and stricter visual QA checklist
- `adlc-release`: migration/backfill and feature flag release references
- `adlc-handoff`: branch transfer examples
- `adlc-skill-maintain`: release checklist and metadata policy

Resolution: deepen the high-risk operational skills first while keeping the full suite coherent.

### 4. Validation Expansion

Current validation checks indexes, manifest entries, frontmatter, links, and script permissions.

Pass 2 should consider adding:

- JSON schema-ish plugin manifest checks
- line-count or size warning for `SKILL.md`
- required reference link existence for specific skills
- central examples index validation
- metadata presence or explicit deferral
- install smoke command if a stable tool supports it
- frontmatter description trigger quality lint

Resolution: validation remains structural and binary.

### 5. Adapter Conventions

ADLC chose hybrid local-first plus optional tracker adapters. The current skill text names the model but does not fully specify adapter behavior.

Pass 2 should define:

- local issue draft conventions
- GitHub issue creation expectations
- Linear issue creation expectations
- other tracker freeform adapter expectations
- label/status mapping
- how tracker links round-trip back into local artifacts

Resolution: Local Markdown, GitHub, and Linear are first-class.

### 6. Public Release Readiness

The first pass targeted operational usability. Pass 2 should decide whether to reach public-release quality.

Potential work:

- README quickstart with recommended first commands
- badges or skill collection metadata
- install smoke test
- changelog/release notes only if repo convention wants them
- GitHub release checklist
- public examples that are safe and generic

Resolution: pass two targets public-release readiness.

## Completed Pass 2 Order

1. Decide examples strategy.
2. Decide cross-agent metadata scope.
3. Decide first-class tracker adapters.
4. Add central examples and templates.
5. Deepen high-risk skill references.
6. Expand validation.
7. Run validation plus install/use smoke checks.
8. Update README and ADRs.
9. Commit the completed pass.

## Closeout Notes

Pass two leaves the repo public-release ready after review:

- `scripts/validate-skills.sh` passes.
- `scripts/smoke-skills.sh` passes.
- `npx skills@latest --help` succeeds, confirming the public CLI is reachable; the CLI does not expose a local repo validation command in help output.
- Formal tagging or publishing remains a separate explicit action.
