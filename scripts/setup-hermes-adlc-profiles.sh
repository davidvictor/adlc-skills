#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v hermes >/dev/null 2>&1; then
  echo "hermes command not found on PATH." >&2
  exit 1
fi

ORCHESTRATOR_PROFILE="${ADLC_HERMES_ORCHESTRATOR_PROFILE:-sprintrunner}"
BUILDER_PROFILE="${ADLC_HERMES_BUILDER_PROFILE:-sprintbuilder}"
REVIEWER_PROFILE="${ADLC_HERMES_REVIEWER_PROFILE:-sprintreviewer}"
FIXER_PROFILE="${ADLC_HERMES_FIXER_PROFILE:-sprintfixer}"
BOARD="${ADLC_HERMES_BOARD:-adlc-sprints}"

ensure_profile() {
  local profile="$1"

  if ! hermes profile show "$profile" >/dev/null 2>&1; then
    hermes profile create "$profile" --clone --no-alias >/dev/null
    echo "Created Hermes profile: $profile"
  fi
}

configure_profile() {
  local profile="$1"
  local reasoning="$2"

  ensure_profile "$profile"
  hermes -p "$profile" config set model.default gpt-5.5 >/dev/null
  hermes -p "$profile" config set model.provider openai-codex >/dev/null
  hermes -p "$profile" config set model.openai_runtime auto >/dev/null
  hermes -p "$profile" config set agent.max_turns 1000 >/dev/null
  hermes -p "$profile" config set agent.reasoning_effort "$reasoning" >/dev/null
  hermes -p "$profile" config set display.personality concise >/dev/null

  echo "Configured $profile:"
  echo "  model.default=gpt-5.5"
  echo "  model.provider=openai-codex"
  echo "  model.openai_runtime=auto"
  echo "  agent.max_turns=1000"
  echo "  agent.reasoning_effort=$reasoning"
}

configure_profile "$ORCHESTRATOR_PROFILE" medium
configure_profile "$BUILDER_PROFILE" xhigh
configure_profile "$REVIEWER_PROFILE" xhigh
configure_profile "$FIXER_PROFILE" xhigh

"$repo_root/scripts/install-hermes-adlc-skills.sh"

if ! hermes kanban boards list 2>/dev/null | grep -Eq "(^|[[:space:]])$BOARD([[:space:]]|$)"; then
  hermes kanban boards create "$BOARD" \
    --name "ADLC Sprints" \
    --description "Reusable Hermes Kanban board for ADLC-packaged sprints." \
    --switch >/dev/null
  echo "Created Hermes Kanban board: $BOARD"
else
  hermes kanban boards switch "$BOARD" >/dev/null
  echo "Using existing Hermes Kanban board: $BOARD"
fi

echo
echo "Verify with:"
echo "  hermes skills list | grep adlc-"
echo "  hermes -p $ORCHESTRATOR_PROFILE skills list | grep adlc-hermes"
echo "  hermes -p $BUILDER_PROFILE skills list | grep adlc-build"
echo "  hermes -p $REVIEWER_PROFILE skills list | grep adlc-audit"
echo "  hermes -p $FIXER_PROFILE skills list | grep -E 'adlc-close|adlc-prove'"
echo "  hermes kanban --board $BOARD list"
echo "  scripts/check-hermes-adlc-ready.sh"
