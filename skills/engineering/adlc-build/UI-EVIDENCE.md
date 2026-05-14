# UI Evidence

Use browser evidence when code-level tests do not prove the user-facing behavior.

## Evidence To Capture

- route or URL inspected
- viewport sizes
- relevant states: loading, empty, error, success, disabled
- keyboard/focus behavior when controls change
- console or network errors when relevant
- screenshots for visual/layout/motion work

## Good UI Evidence

Good:

- "Opened `/requests/42`, high-risk empty note state, submit disabled, error row visible, no console errors."
- "Narrow viewport screenshot shows note field and footer do not overlap."
- "Keyboard tab order moves note field -> submit -> cancel."

Weak:

- "Looks good."
- "Component compiles."
- "I inspected the JSX."

## When Blocked

Name the missing condition:

- app cannot start
- auth unavailable
- seed data missing
- browser tool unavailable

Then name the unverified UI behavior and the smallest follow-up check.
