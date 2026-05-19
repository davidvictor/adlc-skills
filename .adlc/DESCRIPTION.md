---
id: adlc-project-description
type: context
status: active
owner: ADLC
---

# Project Description

This repository packages ADLC, David Victor's agent-driven development lifecycle. It provides local Codex skills, Codex-native agent definitions, a dependency-light Node CLI, runtime install/update management, MCP templates, extension mechanics, artifact auditing, and ADLC-owned documentation.

ADLC is a lean fork of useful AI Factory architecture concepts, not a compatibility clone. The system is intentionally private, Codex-first, file-backed, and tailored to David's workflow.

## Primary Outcomes

- Install and update ADLC skills and Codex agents into local or project runtimes.
- Initialize target projects with `.adlc/` context and lifecycle artifacts.
- Route work through evidence, planning, implementation, verification, review, commit readiness, and evolution.
- Support long-running workstreams that can be handed to Codex or Hermes without losing step state.
- Keep broad optional surfaces such as Docker, CI, build automation, and skill generation out of core until they prove useful through repeated work.

## Main Entry Points

- `bin/adlc.js`: CLI for install, status, update, init, config resolution, MCP, extensions, workstreams, and artifact audit.
- `skills/adlc/`: public ADLC skill package.
- `subagents/codex/agents/`: Codex-native coordinator, worker, and sidecar agents.
- `docs/`: ADLC operator guides and architecture decisions.
- `templates/adlc/config.yaml`: default target-project config.
