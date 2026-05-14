# Architecture Language

Use these terms consistently.

**Module**:
Anything with an interface and an implementation: function, class, package, workflow, or slice.
_Avoid_: component, service, unit.

**Interface**:
Everything a caller must know to use a module correctly: types, invariants, ordering, error modes, config, and performance expectations.
_Avoid_: API, signature.

**Implementation**:
The code and behavior hidden behind an interface.

**Seam**:
The place where behavior can vary without editing the caller.
_Avoid_: boundary.

**Adapter**:
A concrete implementation that satisfies an interface at a seam.

**Depth**:
How much useful behavior sits behind a small, stable interface.

**Leverage**:
What callers get from depth: more capability per concept they must learn.

**Locality**:
What maintainers get from depth: change, bugs, and verification concentrate in one place.

## Principles

- Depth is a property of the interface, not line count.
- The interface is the test surface.
- One adapter is a hypothetical seam. Two adapters make the seam real.
- Prefer deleting shallow indirection over polishing it.
- Replace brittle low-level tests with behavior tests at the deeper interface.
