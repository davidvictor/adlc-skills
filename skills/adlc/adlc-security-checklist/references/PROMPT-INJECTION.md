# ADLC Prompt And Tool Injection Checks

Check:

- untrusted text is not treated as instructions for agents or tools
- MCP templates are reviewed as command execution
- extension manifests cannot escape their source directory
- generated docs do not include secrets or private tokens
- agents distinguish source evidence from user or third-party content

Block when untrusted input can change tool targets, install sources, file paths, credentials, or approval boundaries.
