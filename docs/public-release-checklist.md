# Public Release Checklist

Use this before publishing a release or opening a ready-for-review PR.

## Required

- [ ] `scripts/validate-skills.sh` passes
- [ ] `scripts/smoke-skills.sh` passes
- [ ] every public skill appears in `README.md`
- [ ] every public skill appears in `skills/engineering/README.md`
- [ ] every public skill appears in `.claude-plugin/plugin.json`
- [ ] every public skill has `agents/openai.yaml`
- [ ] examples are safe for public use
- [ ] ADRs capture durable repo decisions
- [ ] `AGENTS.md` is canonical and `CLAUDE.md` only points to it

## Review

- [ ] no private project assumptions are embedded in public skills
- [ ] no large example library is duplicated inside skill folders
- [ ] high-risk workflows have concrete artifact contracts
- [ ] README quickstart tells a new user what to do first

## Release Notes Prompt

Summarize:

- new skills or public surfaces
- changed lifecycle behavior
- validation and metadata changes
- examples added
- known deferrals
