# ADLC Rules Check Contract

`adlc-rules-check` is a read-only compliance gate.

Inputs:

- effective `paths.rules_file`
- effective `paths.rules`
- active plan or diff
- relevant area rule registrations

Output:

- concise human findings
- final `adlc-gate-result` block with `gate: "rules"`

Blocking examples:

- changed scope violates an active rule
- plan omits a required area rule
- rule conflict makes implementation unsafe to continue

Warnings:

- no rule exists for an area where one would help
- rule wording is ambiguous but does not block the current change
