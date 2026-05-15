#!/usr/bin/env bash
set -euo pipefail

ruby - "$@" <<'RUBY'
require "json"
require "optparse"
require "open3"
require "pathname"
require "yaml"

options = {
  mode: "graph",
  board: nil,
  target_folder: nil,
  instructions: "",
  title: nil,
  workspace: nil,
  assignee: nil,
  orchestrator: nil,
  builder: nil,
  reviewer: nil,
  fixer: nil,
  telegram: true,
  telegram_chat_id: ENV["ADLC_HERMES_TELEGRAM_CHAT_ID"] || ENV["TELEGRAM_HOME_CHANNEL"],
  telegram_user_id: ENV["ADLC_HERMES_TELEGRAM_USER_ID"],
  dispatch: true,
  dry_run: false,
  include_hitl: false,
  serial: true,
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: scripts/seed-adlc-hermes-sprint.sh --target-folder PATH [options]"
  opts.on("--target-folder PATH", "Folder containing an ADLC sprint package.") { |v| options[:target_folder] = v }
  opts.on("--instructions TEXT", "Additional or standalone instructions.") { |v| options[:instructions] = v }
  opts.on("--mode MODE", "graph or orchestrator. Default: graph.") { |v| options[:mode] = v }
  opts.on("--board SLUG", "Hermes Kanban board slug.") { |v| options[:board] = v }
  opts.on("--title TEXT", "Task title for orchestrator mode.") { |v| options[:title] = v }
  opts.on("--workspace VALUE", "scratch | worktree | dir:<path>.") { |v| options[:workspace] = v }
  opts.on("--assignee NAME", "Orchestrator profile.") { |v| options[:assignee] = v }
  opts.on("--orchestrator NAME", "Orchestrator profile.") { |v| options[:orchestrator] = v }
  opts.on("--builder-assignee NAME", "Build profile.") { |v| options[:builder] = v }
  opts.on("--reviewer-assignee NAME", "Review profile.") { |v| options[:reviewer] = v }
  opts.on("--fixer-assignee NAME", "Fix/prove/commit profile.") { |v| options[:fixer] = v }
  opts.on("--telegram-chat-id ID", "Subscribe this Telegram chat to task events.") { |v| options[:telegram_chat_id] = v }
  opts.on("--telegram-user-id ID", "Telegram user id for the subscription.") { |v| options[:telegram_user_id] = v }
  opts.on("--no-telegram", "Do not create Telegram subscriptions.") { options[:telegram] = false }
  opts.on("--no-dispatch", "Create tasks but do not dispatch the first ready task.") { options[:dispatch] = false }
  opts.on("--include-hitl", "Seed HITL items as execution tasks instead of leaving them visible only in handoff.") { options[:include_hitl] = true }
  opts.on("--parallel", "Do not serialize items that have no explicit dependency.") { options[:serial] = false }
  opts.on("--dry-run", "Print the planned graph without creating tasks.") { options[:dry_run] = true }
end

parser.parse!(ARGV)

def die(message)
  warn(message)
  exit(1)
end

def run_cmd(*cmd, dry_run: false)
  if dry_run
    puts cmd.map { |part| part.to_s.include?(" ") ? part.inspect : part }.join(" ")
    return "{}"
  end

  stdout, stderr, status = Open3.capture3(*cmd.map(&:to_s))
  unless status.success?
    warn(stderr.empty? ? stdout : stderr)
    die("Command failed: #{cmd.join(" ")}")
  end
  stdout
end

def hermes_available?
  system("command", "-v", "hermes", out: File::NULL, err: File::NULL)
end

def read_hermes_env(key)
  env_path = File.join(ENV["HERMES_HOME"] || File.join(Dir.home, ".hermes"), ".env")
  return nil unless File.file?(env_path)

  File.readlines(env_path).each do |line|
    next unless line =~ /^\s*(?:export\s+)?#{Regexp.escape(key)}=/
    value = line.sub(/^\s*(?:export\s+)?[^=]+=/, "").sub(/\s+#.*$/, "").strip
    return value[1...-1] if value.start_with?("\"", "'") && value.end_with?(value[0])
    return value
  end
  nil
end

def slug(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
end

def manifest_path(target_folder)
  names = %w[
    adlc-sprint.yaml adlc-sprint.yml
    sprint-runner.yaml sprint-runner.yml
    sprint.yaml sprint.yml
    plan.yaml plan.yml
    manifest.yaml manifest.yml
    sprint.json
  ]
  names.map { |name| File.join(target_folder, name) }.find { |path| File.file?(path) }
end

def load_manifest(path)
  if path.end_with?(".json")
    JSON.parse(File.read(path))
  else
    YAML.load_file(path) || {}
  end
end

def array(value)
  case value
  when nil then []
  when Array then value
  else [value]
  end
end

def resolve_path(base, path)
  return nil if path.to_s.empty?
  value = path.to_s
  return value if value.start_with?("/")
  File.expand_path(value, base)
end

def repo_path(manifest, manifest_dir, repo_name)
  repo = (manifest["repos"] || {})[repo_name]
  return nil unless repo
  resolve_path(manifest_dir, repo["path"])
end

def item_workspace(item, manifest, manifest_dir, target_folder)
  isolation = item["isolation_mode"].to_s
  return isolation if isolation.start_with?("dir:") || isolation == "worktree" || isolation == "scratch"

  repos = array(item["repos"])
  if repos.length == 1
    path = repo_path(manifest, manifest_dir, repos.first)
    return "dir:#{path}" if path
  end

  "dir:#{target_folder}"
end

def read_parent_task_id(task_id)
  task_id.to_s
end

def default_telegram_user
  users = ENV["ADLC_HERMES_TELEGRAM_USER_ID"] || ENV["TELEGRAM_ALLOWED_USERS"] || read_hermes_env("TELEGRAM_ALLOWED_USERS")
  users.to_s.split(",").first
end

def ensure_board(board, dry_run)
  if dry_run
    puts "Would ensure board: #{board}"
    return
  end

  list = run_cmd("hermes", "kanban", "boards", "list")
  if list.lines.any? { |line| line.split.include?(board) }
    run_cmd("hermes", "kanban", "boards", "switch", board)
  else
    run_cmd(
      "hermes", "kanban", "boards", "create", board,
      "--name", "ADLC Sprints",
      "--description", "ADLC sprint execution",
      "--switch"
    )
  end
end

def subscribe_task(board, task_id, options)
  return unless options[:telegram]
  chat_id = options[:telegram_chat_id] || read_hermes_env("TELEGRAM_HOME_CHANNEL")
  return if chat_id.to_s.empty?

  args = ["hermes", "kanban", "--board", board, "notify-subscribe", task_id, "--platform", "telegram", "--chat-id", chat_id]
  user_id = options[:telegram_user_id] || default_telegram_user
  args += ["--user-id", user_id] unless user_id.to_s.empty?
  run_cmd(*args)
rescue SystemExit
  warn("Telegram subscription failed for #{task_id}; continuing.")
end

def create_task(board:, title:, assignee:, workspace:, skills:, body:, parents:, key:, max_runtime:, options:)
  args = [
    "hermes", "kanban", "--board", board, "create", title,
    "--assignee", assignee,
    "--workspace", workspace,
    "--idempotency-key", key,
    "--created-by", "adlc-hermes-seed",
    "--max-runtime", max_runtime,
    "--max-retries", "3",
    "--body", body,
    "--json",
  ]
  skills.each { |skill| args += ["--skill", skill] }
  parents.compact.reject(&:empty?).each { |parent| args += ["--parent", parent] }

  if options[:dry_run]
    puts "\nWould create: #{title}"
    puts "  assignee: #{assignee}"
    puts "  workspace: #{workspace}"
    puts "  skills: #{skills.join(", ")}"
    puts "  parents: #{parents.compact.reject(&:empty?).join(", ")}"
    puts "  key: #{key}"
    return "dry-#{key}"
  end

  output = run_cmd(*args)
  parsed = JSON.parse(output)
  task_id = parsed["id"] || die("Could not parse task id for #{title}: #{output}")
  subscribe_task(board, task_id, options)
  warn "Created/reused #{task_id}: #{title}"
  task_id
end

def bullet_list(values)
  array(values).map { |v| "- #{v}" }.join("\n")
end

def verify_lines(item)
  verify = item["verify"] || {}
  return "" unless verify.is_a?(Hash)
  verify.flat_map do |repo, commands|
    ["#{repo}:"] + array(commands).map { |cmd| "  - #{cmd}" }
  end.join("\n")
end

def build_body(item, manifest, manifest_path, target_folder)
  <<~BODY
    Use ADLC build for this sprint item.

    Sprint package: #{target_folder}
    Manifest: #{manifest_path}
    Work item: #{item["id"]} - #{item["title"]}
    Spec: #{item["spec"] || "not provided"}
    Source spec: #{item["source_spec"] || "not provided"}
    Repos: #{array(item["repos"]).join(", ")}

    Acceptance criteria:
    #{bullet_list(item["acceptance"])}

    Verification:
    #{verify_lines(item)}

    Rules:
    - Read repo AGENTS.md files before editing.
    - Keep this item boundary strict.
    - Do not start later sprint items.
    - Do not commit in the build phase; the fix/prove phase owns commits.
    - Do not apply production migrations, provider spend, secrets changes, or destructive commands.
    - Do not block merely because hostile review is required next.
    - Complete with changed_files, verification, acceptance status, review_required=true, residual_risk, and next_adlc_phase=adlc-audit.
    - Block only for human-decision, credential-blocker, environment-blocker, scope-expansion, or unsafe-verification stop conditions.
  BODY
end

def review_body(item, manifest_path, target_folder)
  <<~BODY
    Use ADLC audit for hostile review of this sprint item.

    Sprint package: #{target_folder}
    Manifest: #{manifest_path}
    Work item: #{item["id"]} - #{item["title"]}
    Spec: #{item["spec"] || "not provided"}

    Role:
    - Review the actual diff and build handoff against acceptance criteria.
    - Do not edit files.
    - Run non-mutating checks when useful.
    - Report findings with severity, path, evidence, impact, and fix direction.
    - Emit a finding ledger with id, axis, severity, blocking, scope, evidence, fix_direction, and verification_required.
    - Complete with approved=true only when no blocking findings remain.
    - Complete with approved=false and the finding ledger when fixes are required.
    - Block only when the review cannot run or a human planning decision is needed before any fix agent can proceed.
  BODY
end

def fix_body(item, manifest, manifest_path, target_folder)
  commit_message = item["commit_message"] || "sprint item #{item["id"]}: #{item["title"]}"
  <<~BODY
    Use ADLC close and prove for review fixes, final verification, and commit.

    Sprint package: #{target_folder}
    Manifest: #{manifest_path}
    Work item: #{item["id"]} - #{item["title"]}
    Spec: #{item["spec"] || "not provided"}

    Role:
    - Read the build handoff and hostile review result.
    - Post a short fix plan before editing: finding id, action, files expected to change, verification to rerun, and scope verdict.
    - Fix all in-scope P0/P1/P2 findings or block with exact evidence.
    - Re-run final verification from the work item.
    - Commit only files belonging to this item.
    - Block only for human-decision, credential-blocker, environment-blocker, scope-expansion, or unsafe-verification stop conditions.

    Suggested commit message:
    #{commit_message}

    Complete with commit_hashes, changed_files, verification, findings_resolved, residual_risk, and next_adlc_phase=adlc-handoff.
  BODY
end

def orchestrator_body(target_folder, instructions)
  <<~BODY
    Use ADLC Hermes to execute this ADLC sprint through Hermes Kanban.

    Sprint package:
    - #{target_folder || "not provided"}

    Instructions:
    #{instructions.to_s.empty? ? "- not provided" : instructions}

    Lifecycle gates:
    - Build with adlc-build.
    - Self-verify with the commands named in each work item.
    - Run hostile review with adlc-audit.
    - Create review-fix tasks with adlc-close for blocking findings.
    - Run final verification proof with adlc-prove after fixes.
    - Use adlc-release for production, migration, integration, or user-facing release risk.
    - Use adlc-handoff for continuity and exact next steps.

    Rules:
    - Read adlc-sprint.yaml first, falling back to legacy sprint-runner.yaml only for old packages.
    - Discover available Hermes profiles before creating child tasks.
    - Do not invent assignees.
    - Preserve dependency links from the manifest.
    - Complete normal phase gates so dependent tasks promote automatically.
    - Do not block a build task merely because review is required.
    - Use Kanban comments and blocked state for human decisions, missing credentials, missing environment, destructive approval, unsafe verification, or scope expansion.
    - Do not load the retired sprint-runner skill for new tasks.
  BODY
end

die("hermes command not found on PATH.") unless hermes_available?
die("Provide --target-folder, --instructions, or both.") if options[:target_folder].to_s.empty? && options[:instructions].to_s.empty?

if options[:target_folder]
  die("Target folder does not exist: #{options[:target_folder]}") unless Dir.exist?(options[:target_folder])
  options[:target_folder] = File.expand_path(options[:target_folder])
end

if options[:telegram] && options[:telegram_chat_id].to_s.empty?
  options[:telegram_chat_id] = read_hermes_env("TELEGRAM_HOME_CHANNEL")
end
if options[:telegram] && options[:telegram_user_id].to_s.empty?
  options[:telegram_user_id] = default_telegram_user
end

if options[:mode] == "orchestrator" || options[:target_folder].to_s.empty?
  board = options[:board] || ENV["ADLC_HERMES_BOARD"] || "adlc-sprints"
  assignee = options[:assignee] || options[:orchestrator] || ENV["ADLC_HERMES_ORCHESTRATOR_PROFILE"] || (system("hermes", "profile", "show", "sprintrunner", out: File::NULL, err: File::NULL) ? "sprintrunner" : "default")
  workspace = options[:workspace] || (options[:target_folder] ? "dir:#{options[:target_folder]}" : "scratch")
  title = options[:title] || (options[:target_folder] ? "ADLC Sprint: #{File.basename(options[:target_folder])}" : "ADLC Sprint: instructions")

  ensure_board(board, options[:dry_run])
  task_id = create_task(
    board: board,
    title: title,
    assignee: assignee,
    workspace: workspace,
    skills: ["adlc-hermes", "kanban-orchestrator"],
    body: orchestrator_body(options[:target_folder], options[:instructions]),
    parents: [],
    key: "adlc-hermes-orchestrator-#{slug(title)}",
    max_runtime: "2h",
    options: options
  )
  run_cmd("hermes", "kanban", "--board", board, "dispatch", "--max", "1") if options[:dispatch] && !options[:dry_run]
  puts "Created orchestration task: #{task_id}"
  exit 0
end

target_folder = options[:target_folder]
manifest = manifest_path(target_folder)
die("No ADLC sprint manifest found in #{target_folder}. Use --mode orchestrator to seed a normalization task.") unless manifest

manifest_dir = File.dirname(manifest)
data = load_manifest(manifest)
runner = data["runner"] || {}
profiles = runner["profiles"] || {}
board = options[:board] || runner["board"] || ENV["ADLC_HERMES_BOARD"] || "adlc-sprints"
builder = options[:builder] || profiles["builder"] || ENV["ADLC_HERMES_BUILDER_PROFILE"] || "sprintbuilder"
reviewer = options[:reviewer] || profiles["reviewer"] || ENV["ADLC_HERMES_REVIEWER_PROFILE"] || "sprintreviewer"
fixer = options[:fixer] || profiles["fixer"] || ENV["ADLC_HERMES_FIXER_PROFILE"] || "sprintfixer"

items = array(data["items"])
die("Manifest has no items: #{manifest}") if items.empty?

ensure_board(board, options[:dry_run])

puts "Board: #{board}"
puts "Sprint: #{data["name"] || File.basename(target_folder)}"
puts "Manifest: #{manifest}"
puts "Mode: deterministic graph"
puts "Profiles: build=#{builder}, review=#{reviewer}, fix=#{fixer}"

last_final = nil
final_by_item = {}
created = []
skipped = []

items.each do |item|
  status = item["status"].to_s.upcase
  if !status.empty? && status != "AFK" && !options[:include_hitl]
    skipped << "#{item["id"]} #{item["title"]} (#{status})"
    next
  end

  item_id = item["id"] || slug(item["title"])
  item_slug = slug("#{item_id}-#{item["title"]}")
  workspace = options[:workspace] || item_workspace(item, data, manifest_dir, target_folder)
  dependency_parents = array(item["depends_on"]).map { |dep| final_by_item[dep] }.compact
  dependency_parents << last_final if options[:serial] && dependency_parents.empty? && last_final

  build = create_task(
    board: board,
    title: "#{item_id} build: #{item["title"]}",
    assignee: builder,
    workspace: workspace,
    skills: ["adlc-build"],
    body: build_body(item, data, manifest, target_folder),
    parents: dependency_parents,
    key: "#{slug(board)}-#{item_slug}-build",
    max_runtime: "4h",
    options: options
  )

  review = create_task(
    board: board,
    title: "#{item_id} hostile review: #{item["title"]}",
    assignee: reviewer,
    workspace: workspace,
    skills: ["adlc-audit"],
    body: review_body(item, manifest, target_folder),
    parents: [build],
    key: "#{slug(board)}-#{item_slug}-review",
    max_runtime: "2h",
    options: options
  )

  fix = create_task(
    board: board,
    title: "#{item_id} fix+prove+commit: #{item["title"]}",
    assignee: fixer,
    workspace: workspace,
    skills: ["adlc-close", "adlc-prove"],
    body: fix_body(item, data, manifest, target_folder),
    parents: [review],
    key: "#{slug(board)}-#{item_slug}-fix-prove-commit",
    max_runtime: "4h",
    options: options
  )

  final_by_item[item_id] = fix
  last_final = fix
  created << [item_id, build, review, fix]
end

puts
puts "Task graph:"
created.each do |item_id, build, review, fix|
  puts "- #{item_id}: #{build} -> #{review} -> #{fix}"
end

unless skipped.empty?
  puts
  puts "Skipped non-AFK items:"
  skipped.each { |line| puts "- #{line}" }
end

if options[:dispatch] && !options[:dry_run]
  puts
  puts "Dispatching the first ready task..."
  run_cmd("hermes", "kanban", "--board", board, "dispatch", "--max", "1")
end

puts
puts "Watch progress:"
puts "  hermes kanban --board #{board} list"
puts "  hermes kanban --board #{board} watch"
RUBY
