# Interface Design

Use when a deepening candidate is selected and the interface shape is not obvious.

## Frame

State:

- current caller burden
- behavior that should move behind the interface
- invariants callers should stop knowing
- dependency categories from `DEEPENING.md`
- verification surface after the change

## Design Twice

Produce at least two materially different interface options:

1. Minimal interface: few entry points, maximum leverage.
2. Common-case interface: makes the most frequent caller trivial.
3. Adapter-oriented interface: only when a real seam exists.

For each option include:

- interface surface
- caller example
- implementation hidden behind the seam
- testing strategy
- trade-offs in leverage and locality

Recommend one option or a hybrid. Be opinionated; do not leave the user with a menu unless the trade-off is genuinely product-dependent.
