---
name: adlc-interface
description: Design and implement domain-shaped frontend interfaces. Use when building screens, flows, UI components, visual variants, dashboards, landing pages, or frontend product surfaces.
---

# ADLC Interface

Build interfaces that fit the product job and feel intentionally designed.

## Discover

Inspect the existing app before choosing a direction:

- audience and user/operator goal
- current design system, tokens, components, and layout density
- data states, empty states, loading, errors, permissions, and responsiveness
- accessibility, performance, and technical constraints
- relevant `CONTEXT.md`, ADRs, and ADLC operating contract

Ask at most one direction-setting question if the posture is unclear.

## Choose Posture

Default to domain-shaped design:

- operational tools: quiet density, fast scanning, clear hierarchy
- content or portfolio: editorial craft, strong rhythm, meaningful media
- games or playful tools: expressive motion and responsive feedback
- landing or brand surfaces: memorable first viewport with real product signal
- internal workbenches: durable controls, restrained styling, obvious state

Avoid generic AI aesthetics and avoid novelty that fights the product job.

## Implement

Use existing primitives and tokens, but raise the bar through:

- composition and information hierarchy
- responsive constraints
- real states and edge cases
- accessible controls and focus
- typography, spacing, density, and motion
- tactile details delegated to `adlc-polish` when the work is refinement-heavy

For exploratory directions, use `adlc-spike` UI variants first. For production implementation, keep the diff scoped and production-quality.

## Verify

Use [FRONTEND-VERIFICATION.md](./FRONTEND-VERIFICATION.md). Browser or screenshot proof is required for meaningful visual, layout, motion, responsive, or visual bug-fix work when feasible.

## Closeout

Report:

- chosen posture and why it fits
- surfaces changed
- important states covered
- browser/visual evidence or blocker
- remaining design risks
- whether `adlc-polish`, `adlc-audit`, or `adlc-prove` should run next
