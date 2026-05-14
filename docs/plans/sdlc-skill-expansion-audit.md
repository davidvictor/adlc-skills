# SDLC Skill Expansion Audit

Status: direction-setting audit before skill-body edits.

Target repo: `davidvictor/adlc-skills`

Comparison sources:

- Matt Pocock skills: https://github.com/mattpocock/skills
- Anthropic frontend-design skill: https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md
- Make Interfaces Feel Better: https://github.com/jakubkrehel/make-interfaces-feel-better

## Executive Read

`adlc-skills` has a coherent lifecycle spine but not a complete software development lifecycle yet.

What exists today is strongest around:

- alignment before building
- repo-language anchoring
- architecture mapping
- PRD shaping
- issue slicing
- disposable spikes
- review, closeout, and verification proof

What is missing or too thin:

- per-repo setup/configuration that downstream skills can rely on
- issue intake and triage as a real state machine
- agent-ready brief quality standards
- implementation loop, especially TDD and vertical red-green-refactor
- diagnosis/debugging loop
- handoff and continuity between agent sessions
- release/rollout/operations lifecycle
- frontend product/design skill that combines bold aesthetic direction with precise interaction polish
- examples, scripts, and validation fixtures proving that the skills work as installable public skills

The current repo reads like a strong outline. Matt's repo reads like working operating procedure: it names state, creates repo-local configuration, includes reference files, provides scripts for fragile loops, and gives agents concrete output contracts. ADLC should keep its own voice, but it needs the same degree of operational completeness.

## Current ADLC Inventory

### Existing skills

| ADLC skill | Current responsibility | Strength | Current weakness |
| --- | --- | --- | --- |
| `adlc-probe` | Decision-tree interview before implementation | Clear question shape and upstream-to-downstream order | Generic decision tree; no reusable domain-specific interview banks; no assumption ledger |
| `adlc-anchor` | Probe with `CONTEXT.md` and ADR discipline | Good universal doc conventions | Thinner than Matt's `grill-with-docs`; weaker multi-context handling; no setup contract for where docs live |
| `adlc-map` | High-level map of code area | Compact and likely useful | No output template for complex systems; no guidance for diagrams, sequence flow, ownership, or runtime surfaces |
| `adlc-deepen` | Architecture improvement candidates | Strong ADLC-flavored vocabulary | Missing Matt-level interface design workflow, parallel alternative designs, reference examples, and post-selection plan shape |
| `adlc-shape` | PRD from resolved context | Good tracker-neutral PRD template | Thin on module/test negotiation; no publishing target; user-story depth lower than Matt's `to-prd` |
| `adlc-slice` | Markdown vertical issue drafts | Strong local-first default | No issue tracker setup; no agent brief contract; no intake from existing issues; stops before durable workflow integration |
| `adlc-spike` | Logic/UI throwaway prototype | Good high-level guardrails | UI and logic branches much thinner than Matt's; missing variant quality bar, runnable harness expectations, and frontend craft integration |
| `adlc-audit` | Review diff against standards and spec | Nice two-axis split | Needs richer severity model, evidence checklist, and guidance for absent specs/standards |
| `adlc-close` | Convert findings into fixes/risks/blockers | Strong closure stance | Needs stricter ledger lifecycle, resumption behavior, and commit/PR evidence rules |
| `adlc-prove` | Audit verification claims | Distinct and valuable | Should connect to implementation, debug, CI, release, screenshots, and runtime proof surfaces |

### Existing repo-level assets

| Asset | Current state | Gap |
| --- | --- | --- |
| `README.md` | Clear overview and suggested flow | Does not communicate complete SDLC, missing coverage matrix and install/use expectations |
| `CLAUDE.md` | Minimal contributor rules | Mentions `.claude-plugin/plugin.json`, but does not define validation/release workflow |
| `.claude-plugin/plugin.json` | Lists ten skills | Missing any future setup, implementation, triage, diagnosis, frontend, handoff, or release skills |
| Templates | PRD, issue, ADR, context | Useful but lightweight; need examples and stronger behavioral contracts |
| Scripts | None | Missing validation, listing, fixture, or install sanity checks |
| Example outputs | None | Hard to judge quality or teach future maintainers the intended flavor |
| ADRs | None | No durable record of why ADLC is tracker-neutral, why `adlc-` prefix exists, or how it differs from Matt's repo |

## Direct Comparison To Matt's Active Skill Areas

### Engineering skills

| Matt skill area | ADLC equivalent today | Gap severity | Specific gap |
| --- | --- | --- | --- |
| `grill-with-docs` | `adlc-anchor` | Medium | ADLC has the same concept but less operational detail. It needs stronger multi-context rules, sharper contradiction handling, concrete scenario probing, and an explicit assumption ledger. |
| `diagnose` | None direct | High | ADLC has verification proof after the fact, but no disciplined bug/performance diagnosis lifecycle: reproduce, minimize, hypothesize, instrument, fix, regression-test, cleanup. |
| `triage` | Partial: `adlc-slice` | High | ADLC can create issue drafts but cannot intake, classify, label, ask for missing info, reject, produce AFK briefs, or resume triage state. |
| `improve-codebase-architecture` | `adlc-deepen` | Medium | ADLC has the right vocabulary but lacks Matt's depth: glossary embedded in the main flow, richer candidate shape, interface-design alternatives, dependency categories, and doc side effects. |
| `setup-matt-pocock-skills` | None | High | ADLC assumes universal conventions but has no setup skill to inspect a repo, record issue tracker policy, locate domain docs, and write a durable agent-skills block. |
| `tdd` | None direct | High | ADLC mentions testing in PRDs/issues/proof, but lacks an implementation skill that forces one behavior, one failing test, one minimal implementation, then refactor. |
| `to-issues` | `adlc-slice` | Medium | ADLC is intentionally tracker-neutral and local-first, which is a good flavor choice, but it lacks approved-breakdown iteration, publishing adapters, parent/child issue handling, and agent brief quality rules. |
| `to-prd` | `adlc-shape` | Low/Medium | ADLC has a stronger template in some respects, but needs better module/test negotiation, explicit readiness criteria, and output-location conventions. |
| `zoom-out` | `adlc-map` | Low | ADLC is already stronger here. It should add optional diagram/flow modes, but parity is essentially met. |
| `prototype` | `adlc-spike` | Medium/High | ADLC has the same high-level split but needs Matt-level detail for UI variant routing, logic harnesses, state visibility, disposal, and durable answer capture. |

### Productivity skills

| Matt skill area | ADLC equivalent today | Gap severity | Specific gap |
| --- | --- | --- | --- |
| `grill-me` | `adlc-probe` | Low | ADLC is more structured and aligned with the lifecycle. Add an assumption ledger and better stopping criteria. |
| `handoff` | None | Medium | ADLC lacks a first-class continuity artifact for long-running agent work, context compaction, branch transfer, or next-agent setup. |
| `write-a-skill` | None | Medium | Because this repo is itself a skill collection, ADLC needs a maintainer-facing skill creation/update workflow or repo guidance for adding skills correctly. |
| `caveman` | None | Low | Useful communication mode, but not central to SDLC parity. Could remain intentionally out of scope. |

### Miscellaneous skill areas

| Matt area | ADLC position | Recommendation |
| --- | --- | --- |
| Git guardrails | Missing | Add as setup or repo-hardening guidance, not necessarily as a public ADLC lifecycle skill unless we want tool-specific safety. |
| Pre-commit setup | Missing | Add under `adlc-setup` or a future `adlc-hardening`; avoid turning ADLC into a stack-specific bootstrapper. |
| Scaffolding exercises / migrations | Not relevant | Keep out of scope. |

## Gaps We Should Recognize Explicitly

### 1. No setup contract

The repo says ADLC assumes `CONTEXT.md`, `docs/adr/`, and Markdown issue drafts. That is a philosophy, not an installable operating contract.

Actionable fix:

- Add `adlc-setup`.
- It should inspect `AGENTS.md`/`CLAUDE.md`, remotes, issue tracker conventions, `CONTEXT.md`, `CONTEXT-MAP.md`, ADR locations, `.scratch/`, CI, test commands, and deployment/release surfaces.
- It should write a small `## ADLC` block plus `docs/adlc/` files only after confirming the three lifecycle anchors: work tracking, domain docs, verification commands.

Open direction question:

- Should ADLC stay strict-local by default, or support GitHub/Linear/Jira adapters as first-class configured outputs?

### 2. No issue intake state machine

`adlc-slice` creates work. It does not manage work that arrives from users, issues, bug reports, or feature requests.

Actionable fix:

- Add `adlc-triage`.
- Use canonical states, but keep labels tracker-neutral.
- Produce an agent-ready brief when work is ready.
- Preserve rejected scope in a durable knowledge base.

Open direction question:

- What are David's canonical work states? Candidate: `needs-shaping`, `needs-info`, `ready-for-agent`, `ready-for-human`, `blocked`, `deferred`, `wontfix`.

### 3. No implementation discipline

ADLC currently jumps from planned slices to audit/close/prove. The actual build loop is implicit.

Actionable fix:

- Add `adlc-build` or `adlc-tdd`.
- Require a vertical-slice implementation loop.
- Make behavior-first tests the default where feasible.
- Distinguish "test-first required", "test-first preferred", and "evidence-first acceptable" for UI/prototype/integration work.

Open direction question:

- Should the implementation skill require TDD by default, or should it require a feedback loop with TDD as the preferred path?

### 4. No diagnosis/debugging lifecycle

`adlc-prove` can catch weak verification claims, but it does not help fix a hard bug.

Actionable fix:

- Add `adlc-diagnose`.
- Center it on constructing a fast feedback loop before hypotheses.
- Include nondeterministic bug strategy, instrumentation cleanup, regression test decision rules, and post-mortem handoff to `adlc-deepen` when architecture blocks proof.

Open direction question:

- How aggressive should ADLC be about temporary instrumentation and harnesses in production repos?

### 5. No frontend design/craft skill

The repo has no equivalent to Anthropic's frontend-design skill or Jakub's polish skill.

Actionable fix:

- Add `adlc-interface` or `adlc-frontend-craft`.
- Combine:
  - bold concept selection, purpose, tone, differentiation, and anti-generic aesthetic direction
  - precise interaction craft: concentric radii, optical alignment, shadows vs borders, interruptible motion, staggered entrances, subtle exits, icon transitions, font smoothing, tabular numbers, text wrapping, image outlines, hit areas, and transition performance
  - ADLC workflow: ask only the direction-setting questions that alter the design, use real repo constraints, implement real code, verify with screenshots/browser, and record decisions if a design becomes product doctrine

Open direction question:

- Should this skill be a standalone frontend skill, or integrated into `adlc-spike` and a new `adlc-polish` review skill?

### 6. No release/operations skill

The lifecycle should not end at "tests passed". Production-quality SDLC includes rollout, rollback, monitoring, release notes, migration safety, and post-release evidence.

Actionable fix:

- Add `adlc-release`.
- It should inspect deployment path, config/env changes, migrations, data backfills, flags, operator docs, smoke tests, rollback command, and post-ship monitoring evidence.

Open direction question:

- Is ADLC intended for local/private solo repos only, or should it include team-grade release/incident expectations?

### 7. No handoff skill

ADLC is agent-native. It needs a way to preserve work across context windows, branches, and operators.

Actionable fix:

- Add `adlc-handoff`.
- It should reference existing artifacts, avoid duplicating PRDs/issues/ADRs, list current branch/diff/tests/blockers, and recommend next ADLC skill.

Open direction question:

- Should handoff artifacts be temporary by default, or written into `.scratch/adlc-handoffs/` when attached to a branch?

### 8. No public-quality validation harness

Strong skill repos make it easy to see and validate what is installed. ADLC currently has no scripts or examples.

Actionable fix:

- Add a small `scripts/list-skills.sh`.
- Add a validation script that checks every public skill appears in README, engineering README, and `.claude-plugin/plugin.json`.
- Add examples under each skill only when they improve agent behavior; otherwise keep examples in a compact `examples/` or `docs/examples/` area.

Open direction question:

- Should we keep this repo Claude-plugin-only, or make it explicitly cross-agent with OpenAI/Codex metadata too?

## Proposed ADLC Lifecycle Map

| Lifecycle phase | Existing / proposed skill | Status |
| --- | --- | --- |
| Setup repo operating contract | `adlc-setup` | Add |
| Fuzzy idea interview | `adlc-probe` | Expand |
| Domain/doc anchored interview | `adlc-anchor` | Expand |
| Codebase map | `adlc-map` | Expand lightly |
| Architecture improvement | `adlc-deepen` | Expand significantly |
| Frontend/interface direction | `adlc-interface` | Add |
| PRD/spec shaping | `adlc-shape` | Expand |
| Issue/work slicing | `adlc-slice` | Expand |
| Issue intake/state triage | `adlc-triage` | Add |
| Throwaway prototype | `adlc-spike` | Expand significantly |
| Implementation loop | `adlc-build` or `adlc-tdd` | Add |
| Debug/diagnosis | `adlc-diagnose` | Add |
| Diff/spec audit | `adlc-audit` | Expand |
| Review closeout | `adlc-close` | Expand |
| Verification proof | `adlc-prove` | Expand |
| Release/rollout | `adlc-release` | Add |
| Handoff/continuity | `adlc-handoff` | Add |
| Skill repo maintenance | `adlc-skill-maintain` | Consider |

## Frontend Skill Direction

The frontend skill should not simply paste together the two reference skills. It should have a distinct ADLC voice:

- Design is a lifecycle activity, not decoration.
- The first question is what user/operator outcome changes.
- The second question is the design posture: quiet utility, editorial craft, playful tool, dense operational surface, product marketing, internal workbench, etc.
- Aesthetic boldness must still obey repo constraints, real data density, accessibility, responsiveness, and performance.
- Polish is concrete and reviewable at the property level.
- Verification requires seeing the UI in a browser, ideally with real or representative states.

Recommended structure:

```text
skills/engineering/adlc-interface/
|-- SKILL.md
|-- VISUAL-DIRECTION.md
|-- POLISH-CHECKLIST.md
|-- MOTION.md
|-- FRONTEND-VERIFICATION.md
`-- REVIEW-OUTPUT.md
```

Core workflow:

1. Inspect the existing app, design system, tokens, components, and visual density.
2. Ask at most one direction-setting question if the design target is ambiguous.
3. State the chosen design posture and why it fits the product.
4. Implement real code using existing primitives where possible.
5. Apply micro-polish deliberately, not generically.
6. Verify with browser screenshots at relevant states/viewports.
7. Output a before/after table for concrete UI detail changes.

Expected quality bar:

- No generic AI surface defaults.
- No decorative novelty that fights the product job.
- No text overflow, layout overlap, or illegible responsive states.
- No unverified animation or screenshot claims.
- No `transition: all`.
- Dynamic numbers use stable numeric rendering.
- Interactive targets have usable hit areas.
- Nested radii are intentional.
- Image/media edges are handled.
- Design decisions that become product doctrine move into `CONTEXT.md` or ADRs.

## Recommended Edit Order After Interview

1. Add `adlc-setup` so all later skills have a repo operating contract.
2. Add `adlc-build`/`adlc-tdd` and `adlc-diagnose`, because these fill the biggest SDLC hole.
3. Expand `adlc-slice` and add `adlc-triage` plus agent brief references.
4. Add `adlc-interface` and wire frontend quality into `adlc-spike`, `adlc-audit`, and `adlc-prove`.
5. Expand `adlc-deepen` with interface design alternatives and dependency categories.
6. Add `adlc-handoff` and `adlc-release`.
7. Add scripts and validation checks.
8. Update README, engineering README, plugin manifest, and ADRs.

## Interview Questions For David

These are not permission questions. They are direction-setting questions that determine the shape of the lifecycle before skill bodies are expanded.

### Lifecycle philosophy

1. Should ADLC be a universal, tracker-neutral lifecycle by default, or should it ship first-class adapters for GitHub/Linear/Jira while still allowing local Markdown?
2. Is "ADLC" primarily for solo agent work, team handoff, or both?
3. Should ADLC skills default to doing work autonomously after gathering enough evidence, or should planning/interview skills keep stronger human checkpoints?

### Work state model

4. What canonical states do you want for intake and triage?
5. What should count as "ready for agent" in your process?
6. When a request is rejected, do you want durable out-of-scope memory in the repo?

### Implementation discipline

7. Should the implementation skill be named `adlc-build`, `adlc-tdd`, or something else?
8. Should TDD be mandatory by default, or should "construct a strong feedback loop" be the mandatory rule with TDD preferred?
9. How should ADLC handle UI work where behavior tests are weak but browser/screenshot verification is strong?

### Frontend flavor

10. What frontend posture should ADLC prefer when no product-specific brand exists: quiet operational clarity, bold editorial craft, or a decision based entirely on audience/domain?
11. Should the frontend skill optimize for creating new designs, polishing existing designs, or both?
12. How hard should it push against generic design systems like shadcn defaults when the existing repo already uses them?

### Repo and release standards

13. Should ADLC include release/rollback/monitoring as a required lifecycle phase, or only when the repo has production deployment?
14. Do you want cross-agent packaging metadata for Codex/OpenAI in addition to the current Claude plugin manifest?
15. Should examples live inside each skill folder, or in central docs so installed skills stay lean?

## Initial Recommendation

Keep ADLC's current personality: concise, universal, evidence-oriented, and allergic to fake certainty.

But expand from "a set of good lifecycle prompts" into "an operating system for agentic software development":

- repo setup creates the operating contract
- probe/anchor shape the decision tree
- map/deepen improve system understanding
- shape/slice/triage convert intent into ready work
- spike/interface explore unknowns
- build/diagnose implement and fix with feedback loops
- audit/close/prove prevent fake completion
- release/handoff preserve operational continuity

The suite should exceed Matt's repo by being less tracker-specific, more verification-explicit, and stronger on frontend craft. It should borrow Matt's discipline around state machines, setup, and concrete artifacts without copying his exact process vocabulary.
