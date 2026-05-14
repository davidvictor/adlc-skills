# UI Spike

Use for screens, flows, layouts, hierarchy, and interaction options.

## Process

1. State the UI question.
2. Prefer mounting variants inside an existing page or route so they inherit real data, density, shell, auth, and constraints.
3. Create 3 radically different variants by default. Cap at 5.
4. Make variants structurally different, not color tweaks.
5. Switch variants with a URL parameter or equivalent shareable state.
6. Add a small visible switcher that is clearly not part of the real design.
7. Hide the switcher in production builds.
8. Verify the route renders in a browser when feasible.
9. Hand over the URL and variant names.
10. Capture the winning direction and delete or absorb the rest.

## Variant Quality

Each variant should differ in at least two of:

- information hierarchy
- interaction model
- density
- navigation or task flow
- visual posture
- motion rhythm

Use `adlc-interface` for production implementation and `adlc-polish` for refinement once a direction wins.

## Anti-Patterns

- variants that differ only in color, copy, or spacing
- empty standalone pages when an existing page could host the variants
- real mutations
- promoting spike code directly without rewriting production-quality behavior
- leaving losing variants in the repo
