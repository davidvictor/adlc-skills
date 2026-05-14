# ADLC Skills Agent Guide

This repository is a public skill collection for the Agent Development Lifecycle.

## Canonical Guidance

`AGENTS.md` is the canonical agent guidance file for this repo. `CLAUDE.md` should only point here.

## Skill Rules

Every public skill must:

- live under `skills/engineering/adlc-<name>/`
- use the `adlc-` prefix in its folder and frontmatter `name`
- include a concise `SKILL.md`
- include `agents/openai.yaml`
- appear in the top-level `README.md`
- appear in `skills/engineering/README.md`
- appear in `.claude-plugin/plugin.json`

Do not add repo-specific private workflow assumptions to public skills. Use universal conventions: `CONTEXT.md`, `CONTEXT-MAP.md`, `docs/adr/`, `docs/adlc/`, `.scratch/adlc-*`, and Markdown issue drafts by default. External trackers are optional adapters configured by `adlc-setup` or explicitly requested by the user.

## Skill Writing Standards

- Keep `SKILL.md` focused on activation, workflow, and closeout.
- Move task-critical detail into one-level reference files beside `SKILL.md`.
- Prefer concrete output contracts over broad advice.
- Ask only in planning/interview skills when decisions are unresolved; implementation and closeout skills should proceed unless genuinely blocked.
- Preserve ADLC's voice: concise, evidence-oriented, tracker-neutral by default, and honest about unverified claims.
- Borrow general skill-writing best practices, but do not closely paraphrase comparison repos.

## Packaging And Validation

Before closeout, run:

```bash
scripts/validate-skills.sh
```

Use `scripts/list-skills.sh` to inspect the public skill set.
Use `scripts/smoke-skills.sh` for a local public-readiness smoke check.

Validation must pass before claiming the repo is internally consistent. If validation fails, fix the repo rather than weakening the script.

## Durable Decisions

Record hard-to-reverse skill-suite decisions in `docs/adr/`. Use ADRs for lifecycle shape, packaging policy, default storage contracts, or guidance that future agents are likely to re-litigate.

## Examples Policy

Use a hybrid examples model:

- small task-critical references live inside the relevant skill folder
- larger examples, golden outputs, and fixture libraries belong in central docs or examples folders

Do not add large example libraries unless they materially improve operational usability.
