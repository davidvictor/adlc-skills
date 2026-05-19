---
id: adlc-docs-index
type: docs-index
status: active
owner: ADLC
---

# ADLC Documentation

This directory is the operator guide for ADLC. It is not a mirror of AI Factory docs; it is our version of the factory concepts, renamed and narrowed for David's workflow.

## Start Here

- [Getting Started](./getting-started.md)
- [Workflow](./workflow.md)
- [Configuration](./configuration.md)
- [Config Reference](./config-reference.md)
- [Skills](./skills.md)
- [Subagents](./subagents.md)

## Lifecycle Guides

- [Plan Files](./plan-files.md)
- [Workstreams](./workstreams.md)
- [Quality Gates](./quality-gates.md)
- [Loop](./loop.md)
- [Evolve](./evolve.md)
- [Artifact Audit](./artifact-audit.md)

## Framework Guides

- [Runtimes](./runtimes.md)
- [MCP](./mcp.md)
- [Extensions](./extensions.md)
- [Security](./security.md)

## Factory Guide Coverage

These are ADLC-owned guides, not links back to upstream manuals. Each guide keeps the useful factory concept, renames it into ADLC language, and drops upstream surface area that does not match our workflow.

| Upstream guide | ADLC guide | ADLC interpretation |
| --- | --- | --- |
| `getting-started.md` | [Getting Started](./getting-started.md) | Local Codex install, project init, and first lifecycle run. |
| `workflow.md` | [Workflow](./workflow.md) | Evidence, plan, implementation, gates, review, commit readiness, and learning. |
| `configuration.md` | [Configuration](./configuration.md) | `.adlc/config.yaml` as the project contract agents resolve before writing artifacts. |
| `config-reference.md` | [Config Reference](./config-reference.md) | The supported lean config keys ADLC actually reads today. |
| `skills.md` | [Skills](./skills.md) | The public ADLC skill surface and ownership boundaries. |
| `subagents.md` | [Subagents](./subagents.md) | Codex coordinators, workers, and read-only sidecars. |
| `quality-gates.md` | [Quality Gates](./quality-gates.md) | Parseable ADLC gate results for verify, rules-check, and review. |
| `plan-files.md` | [Plan Files](./plan-files.md) | Plan artifact shape, task status, and commit checkpoint expectations. |
| `loop.md` | [Loop](./loop.md) | Bounded continuous improvement loops with explicit stop criteria. |
| `evolve.md` | [Evolve](./evolve.md) | Promotion of repeated learnings into durable rules, docs, or skills. |
| `extensions.md` | [Extensions](./extensions.md) | Local workflow packs, deliberately smaller than a remote marketplace. |
| `security.md` | [Security](./security.md) | Minimal operator safety rules for installs, MCP, extensions, and managed state. |

ADLC adds four guides because our fork needs them as first-class surfaces:

- [Runtimes](./runtimes.md) for the lean runtime installer.
- [MCP](./mcp.md) for template-based MCP auto-config.
- [Artifact Audit](./artifact-audit.md) for metadata and relationship checks.
- [Workstreams](./workstreams.md) for long-running managed epic execution.

## Architecture Record

- [AI Factory Port Audit](./ai-factory-port-audit.md)
- [Factory Parity Gap Plan](./factory-parity-gap-plan.md)
- [Gate Result Schema](./gate-result-schema.md)
- [Workstream ADR](./adr/0003-workstreams-for-managed-epics.md)
- [ADRs](./adr/)
