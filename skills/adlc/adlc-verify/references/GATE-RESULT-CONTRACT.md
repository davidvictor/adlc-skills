# ADLC Gate Result Contract

Every verify run ends with one final fenced `adlc-gate-result` JSON block.

Required fields:

- `schema_version`
- `gate`
- `status`
- `blocking`
- `blockers`
- `affected_files`
- `suggested_next`

Use `status: "pass"` only when all acceptance criteria are evidenced. Use `status: "warn"` for non-blocking uncertainty. Use `status: "fail"` when a blocker prevents commit, merge, release, or the requested next lifecycle step.
