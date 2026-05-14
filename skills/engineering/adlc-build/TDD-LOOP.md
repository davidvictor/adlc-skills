# TDD Loop

Use this when the changed behavior has a correct test seam.

## Red

- Write one failing test for one behavior.
- Name the behavior in domain language.
- Assert through the public interface.
- Watch the test fail for the expected reason.

## Green

- Write the smallest production change that passes the test.
- Do not implement future behavior early.
- Rerun the focused test.

## Refactor

- Improve names, locality, and duplication only while green.
- Keep tests at the public interface.
- Delete shallow tests replaced by deeper behavior tests.

## Repeat

Move to the next behavior only after the current loop is green.

## Exceptions

If a failing test would be artificial or misleading, document the better feedback loop and why it is stronger.
