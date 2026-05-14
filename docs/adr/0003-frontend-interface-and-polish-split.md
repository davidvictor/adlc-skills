# Split Frontend Direction From Polish Review

Status: Accepted

## Context

Frontend work has two different modes:

- choosing the product/design direction and implementing a coherent interface
- refining an existing interface through precise tactile details

Combining both into one skill risks making the strategic workflow too checklist-heavy or making the polish workflow too vague.

## Decision

ADLC uses two frontend skills:

- `adlc-interface` for domain-shaped frontend direction and implementation
- `adlc-polish` for tactile review and refinement

Both skills respect existing design systems but raise the bar through composition, density, state, motion, typography, and interaction details.

## Consequences

Frontend work gets a lifecycle lane without turning every UI task into a redesign. `adlc-interface` can choose posture from audience and product job; `adlc-polish` can apply concrete property-level improvements and verification.
