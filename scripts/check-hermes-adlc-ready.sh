#!/usr/bin/env bash
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BOARD="${ADLC_HERMES_BOARD:-adlc-sprints}"
ORCHESTRATOR_PROFILE="${ADLC_HERMES_ORCHESTRATOR_PROFILE:-sprintrunner}"
BUILDER_PROFILE="${ADLC_HERMES_BUILDER_PROFILE:-sprintbuilder}"
REVIEWER_PROFILE="${ADLC_HERMES_REVIEWER_PROFILE:-sprintreviewer}"
FIXER_PROFILE="${ADLC_HERMES_FIXER_PROFILE:-sprintfixer}"

failures=0

pass() {
  printf 'PASS: %s\n' "$1"
}

warn() {
  printf 'WARN: %s\n' "$1" >&2
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    pass "$1 found"
  else
    fail "$1 not found on PATH"
  fi
}

profile_config_path() {
  local profile="$1"
  if [[ "$profile" == "default" ]]; then
    printf '%s\n' "$HERMES_HOME/config.yaml"
  else
    printf '%s\n' "$HERMES_HOME/profiles/$profile/config.yaml"
  fi
}

check_profile() {
  local profile="$1"
  local expected_skill="$2"
  local config_path
  local skills_output

  if hermes profile show "$profile" >/dev/null 2>&1; then
    pass "profile exists: $profile"
  else
    fail "missing Hermes profile: $profile"
    return
  fi

  config_path="$(profile_config_path "$profile")"
  if [[ -f "$config_path" ]]; then
    if grep -Eq 'provider:[[:space:]]*openai-codex|provider.*openai-codex' "$config_path"; then
      if grep -Eq 'openai_runtime:[[:space:]]*auto|openai_runtime.*auto' "$config_path"; then
        pass "$profile uses openai_runtime=auto"
      else
        fail "$profile should use model.openai_runtime=auto"
      fi
    else
      warn "$profile is not configured for provider=openai-codex; skipping openai_runtime check"
    fi
  else
    warn "config not found for $profile at $config_path"
  fi

  skills_output="$(hermes -p "$profile" skills list --enabled-only)"

  if grep -q "$expected_skill" <<<"$skills_output"; then
    pass "$profile can see $expected_skill"
  else
    fail "$profile cannot see $expected_skill"
  fi

  if grep -Eq 'kanban-worker|kanban-orchestrator' <<<"$skills_output"; then
    pass "$profile can see a Kanban skill"
  else
    fail "$profile cannot see kanban-worker or kanban-orchestrator"
  fi
}

check_command hermes

if command -v hermes >/dev/null 2>&1; then
  boards_output=""
  hermes version || true

  if hermes gateway status >/dev/null 2>&1; then
    pass "Hermes gateway status command succeeded"
  else
    fail "Hermes gateway status command failed"
  fi

  check_profile "$ORCHESTRATOR_PROFILE" "adlc-hermes"
  check_profile "$BUILDER_PROFILE" "adlc-build"
  check_profile "$REVIEWER_PROFILE" "adlc-audit"
  check_profile "$FIXER_PROFILE" "adlc-close"
  check_profile "$FIXER_PROFILE" "adlc-prove"

  boards_output="$(hermes kanban boards list --all 2>/dev/null || true)"
  if grep -Eq "(^|[[:space:]])$BOARD([[:space:]]|$)" <<<"$boards_output"; then
    pass "board exists: $BOARD"
    hermes kanban --board "$BOARD" diagnostics || warn "board diagnostics failed for $BOARD"
    board_list="$(hermes kanban --board "$BOARD" list 2>/dev/null || true)"
    if grep -q 'review-required:' <<<"$board_list"; then
      warn "$BOARD has blocked review-required tasks; complete the build handoff or unblock before seeding more dependent work"
    fi
  else
    warn "board does not exist yet: $BOARD"
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  printf '\n%s readiness failure(s)\n' "$failures" >&2
  exit 1
fi

printf '\nHermes ADLC readiness checks passed.\n'
