# ADLC Docs Review Checklist

Use this checklist when documentation is part of a change.

- Does the nearest owner doc explain the shipped behavior?
- Does README mention new public commands or surfaces?
- Does `docs/README.md` link new guides?
- Does `adlc audit-artifacts --strict` pass for tracked docs?
- Are omitted surfaces documented as deliberate ADLC decisions?
- Are examples ADLC-native rather than copied upstream names?
- Did validation gain a check for the new doc contract when the behavior is important?
