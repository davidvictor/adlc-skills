# ADLC Auth And Authorization Patterns

Check:

- authentication is enforced at the boundary that receives untrusted requests
- authorization checks use server-side state, not client claims alone
- service tokens are scoped to the minimum required permissions
- privileged operations have explicit ownership and logging
- test fixtures do not normalize insecure defaults

Block when a changed path can expose private data, bypass authorization, or grant unintended write access.
