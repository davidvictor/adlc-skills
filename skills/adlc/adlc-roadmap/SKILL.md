---
name: adlc-roadmap
description: Create or maintain ADLC roadmap artifacts for milestones, sequencing, and long-range direction.
---

# ADLC Roadmap

Use this when work needs durable milestone sequencing before plans are written.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read configured description, architecture, rules, roadmap, interview specs, and existing plans.
3. Use `adlc-interview` when roadmap sequencing depends on unresolved user priorities, non-goals, or decision boundaries.
4. Write or update the configured roadmap path.
5. Separate now, next, later, blocked, and explicitly rejected work.
6. Tie roadmap items to concrete plans, docs, rules, interview specs, or decisions when they exist.
7. Do not implement code from the roadmap skill.

## Output

Return the roadmap path, material changes, blocked decisions, and the next command: `adlc-interview`, `adlc-plan`, `adlc-rules`, or `adlc-explore`.
