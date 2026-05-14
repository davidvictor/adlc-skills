# Deepening Dependency Categories

Classify dependencies before proposing an interface.

## In-Process

Pure computation or in-memory state. Usually safe to merge behind a deeper interface and test directly.

## Local-Substitutable

I/O with a local stand-in: local filesystem, in-memory queue, local database, fake clock. Test through the deeper interface with the stand-in.

## Remote But Owned

Another service owned by the same team or organization. Define a port at the seam only when the network boundary is real and meaningful. Use production and test adapters.

## True External

Third-party services. Inject a port and use a fake or mock adapter for tests.

## Seam Discipline

- One adapter is a hypothetical seam.
- Two adapters make the seam real.
- Internal seams can exist inside a deep module without becoming part of its public interface.
- Do not expose a seam only because tests want to reach into implementation details.

## Test Strategy

- Test through the new interface.
- Delete tests that only preserved shallow module shapes.
- Keep tests that exercise externally visible behavior.
- If no good seam exists, name that as the architectural finding.
