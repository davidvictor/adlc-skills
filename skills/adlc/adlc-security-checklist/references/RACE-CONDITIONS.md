# ADLC Race And State Checks

Check:

- update/install commands do not silently overwrite drifted managed artifacts
- state files are written after successful artifact sync
- remove flows verify installed hashes before deleting managed artifacts
- multiple workers have disjoint write scopes
- generated config changes are idempotent

Block when concurrent or repeated execution can corrupt state, remove user work, or make verification misleading.
