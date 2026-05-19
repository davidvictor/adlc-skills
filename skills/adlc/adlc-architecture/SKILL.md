---
name: adlc-architecture
description: Create or refresh ADLC architecture artifacts from repo evidence and lifecycle context.
---

# ADLC Architecture

Use this when project structure, ownership boundaries, runtime behavior, or major integration decisions need a durable architecture artifact.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read the configured description, rules, roadmap, active plans, and relevant source files.
3. Identify actual modules, data/control flow, runtime boundaries, agent responsibilities, and integration points.
4. Update only the configured architecture artifact unless the user asks for broader docs.
5. Preserve uncertainty as open questions rather than inventing architecture.
6. Keep diagrams and summaries focused on the system operators actually need to maintain.

## Output

Report the architecture artifact path, evidence sources, changed sections, unresolved questions, and whether `adlc-plan`, `adlc-docs`, or `adlc-rules` should follow.
