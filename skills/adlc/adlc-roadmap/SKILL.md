---
name: adlc-roadmap
description: Create or maintain ADLC roadmap artifacts for milestones, sequencing, and long-range direction.
---

# ADLC Roadmap

Use this when work needs durable milestone sequencing before plans are written.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read configured description, architecture, rules, roadmap, and existing plans.
3. Write or update the configured roadmap path.
4. Separate now, next, later, blocked, and explicitly rejected work.
5. Tie roadmap items to concrete plans, docs, rules, or decisions when they exist.
6. Do not implement code from the roadmap skill.

## Output

Return the roadmap path, material changes, blocked decisions, and the next command: `adlc-plan`, `adlc-rules`, or `adlc-explore`.
