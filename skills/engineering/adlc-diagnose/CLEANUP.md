# Diagnosis Cleanup

Before closeout, verify:

- temporary logs removed
- debug prefixes searched and cleared
- local harness deleted or clearly marked
- fixture data is safe to keep
- no credentials or private payloads were committed
- regression proof runs against the original symptom
- if no regression seam exists, the architecture gap is named

Use a unique marker for temporary instrumentation, such as `DEBUG-<short-id>`, so cleanup is searchable.
