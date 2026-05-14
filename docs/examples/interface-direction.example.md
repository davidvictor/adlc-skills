# Example Interface Direction

# Interface Direction: Approval Dialog

## Product Job

Help an operations manager approve or reject a request quickly while slowing them down just enough for high-risk approvals.

## Posture

Quiet operational clarity. The dialog should feel like a work surface, not a marketing moment.

## Existing System

- Uses compact modal primitives.
- Buttons already have clear primary/secondary hierarchy.
- Risk badges exist in request tables.

## Direction

- Keep the modal compact.
- Put risk context above the note field.
- Use progressive validation: disabled submit until the note meets the rule, with inline explanation.
- Preserve keyboard flow from note field to submit.
- Avoid large decorative warning panels; the risk badge and note requirement carry the weight.

## States To Render

- low-risk approval with optional note
- high-risk empty note
- high-risk whitespace-only note
- high-risk valid note
- audit write failure

## Verification

Browser screenshots for default, invalid, and valid high-risk states at desktop and narrow modal widths.
