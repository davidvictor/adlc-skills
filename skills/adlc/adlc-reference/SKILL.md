---
name: adlc-reference
description: Create concise ADLC reference artifacts from external docs, repos, or local source material.
---

# ADLC Reference

Use this when future agents need durable context extracted from a source.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Prefer primary sources and record source paths or URLs.
3. Write references under the configured references path.
4. Summarize only reusable facts, constraints, commands, schemas, and decisions.
5. Include artifact frontmatter when the reference should be tracked.
6. Separate observed source facts from inference.

## Output

Report reference paths, source material used, confidence, gaps, and the next lifecycle command that should consume the reference.
