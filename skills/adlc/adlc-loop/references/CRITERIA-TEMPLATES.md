# ADLC Loop Criteria Templates

Use explicit criteria before starting a loop.

## Quality Criterion

- Target: behavior, test, doc, or workflow.
- Metric: command, reviewer finding count, artifact state, or manual check.
- Stop: exact condition that ends the loop.

## Example

```markdown
Criterion: validation stability
Metric: `node bin/adlc.js validate` and `bash scripts/test-adlc-cli.sh`
Stop: both commands pass twice after the final code change
Max iterations: 3
```
