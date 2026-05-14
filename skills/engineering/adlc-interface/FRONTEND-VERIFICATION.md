# Frontend Verification

Use tiered verification.

## Browser Proof Required

Run the app and inspect rendered UI for:

- new screens or flows
- redesigns
- layout or responsive work
- motion and interaction work
- visual bug fixes
- work involving media, canvas, charts, or 3D
- changes to shared components with visible downstream impact

Capture evidence across relevant:

- viewport sizes
- light/dark or theme states
- loading, empty, error, disabled, and success states
- authenticated/permission states when applicable

## Targeted Checks Are Enough

For copy, docs, token naming, or isolated code-only changes, use the smallest honest check and explain why browser proof was not needed.

## Visual Failure Modes

Actively check:

- text overflow or clipping
- overlapping UI
- invisible focus
- hit areas below expected size
- motion that cannot be interrupted
- layout shift from dynamic content
- media that is missing, cropped badly, or too decorative
- color contrast and theme mismatches

If blocked, state the missing condition and the exact unverified behavior.
