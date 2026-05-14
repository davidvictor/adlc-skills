# Feedback Loops

Pick the smallest loop that honestly exercises the intended behavior.

## Preferred Order

1. Failing behavior test through a public interface.
2. Integration or e2e test using real project wiring.
3. CLI command with fixture input and expected output.
4. Browser flow with DOM, console, network, and screenshot evidence.
5. Static checks plus targeted inspection for docs/config-only changes.
6. Manual reproduction with captured notes when automation is not feasible.

## Loop Quality

Strong loops are:

- fast enough to rerun often
- deterministic or intentionally stress non-determinism
- specific to the changed behavior
- runnable by another agent or maintainer
- connected to acceptance criteria

Weak loops:

- pass without touching changed behavior
- rely only on implementation shape
- require unstated local state
- are stale, skipped, or no-op commands

## If No Good Loop Exists

Name that as an implementation risk. Create the smallest honest evidence path and recommend architecture or test-surface work if the lack of a seam is the real problem.
