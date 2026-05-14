---
name: adlc-polish
description: Refine frontend interfaces through concrete tactile details. Use when a UI feels off, needs polish, or needs review of typography, spacing, motion, surfaces, hit areas, or visual states.
---

# ADLC Polish

Make existing UI feel deliberate without redesigning the product around it.

## Inspect

Review the rendered interface when feasible. Read existing component and token patterns before changing details.

Use [POLISH-CHECKLIST.md](./POLISH-CHECKLIST.md) as the working checklist.
Use [VISUAL-QA.md](./VISUAL-QA.md) before claiming visual work is verified.
Use [REVIEW-REPORT.md](./REVIEW-REPORT.md) for review output.

## Rules

- Preserve the product posture chosen by the repo or `adlc-interface`.
- Use existing primitives and tokens when they are earning their keep.
- Improve concrete properties, not vibes.
- Avoid `transition: all`.
- Keep hit areas usable.
- Use browser/screenshot verification for meaningful visual, layout, motion, responsive, or bug-fix work.
- Do not add a new dependency only for a tiny polish effect.

## Output

When reviewing or summarizing changes, group by principle:

```markdown
### <Principle>

| Before | After |
| --- | --- |
| <specific property or behavior> | <specific improvement> |
```

Omit empty groups.

## Closeout

Report:

- polish principles applied
- files or surfaces changed
- browser/visual verification
- details intentionally left unchanged
- remaining risks or not-verified states
