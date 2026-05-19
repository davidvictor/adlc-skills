# Example ADLC Plan

---
id: add-health-check
mode: fast
status: ready
owner: codex
created: 2026-05-19
---

## Goal

Add a `/health` endpoint that returns build version, uptime, and database reachability.

## Context

- Project description: `.adlc/DESCRIPTION.md`
- Architecture: `.adlc/ARCHITECTURE.md`
- Rules: `.adlc/RULES.md`

## Tasks

1. Add the endpoint.
   - Scope: server route only.
   - Verification: route returns 200 in local dev and production build.
2. Add tests.
   - Scope: route behavior and error fallback.
   - Verification: focused test command passes.
3. Update docs only if an operator needs to call the endpoint.

## Commit Plan

- `feat: add health endpoint`

## Gate Policy

- Run `adlc-verify`.
- Run `adlc-review`.
- Use `adlc-commit` only after gates pass or warnings are accepted.
