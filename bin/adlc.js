#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { spawnSync } = require('child_process');

const repoRoot = path.resolve(__dirname, '..');
const defaultAuditTargets = ['.adlc', 'docs', 'README.md', 'AGENTS.md'];
const relationFields = ['depends_on', 'affects', 'implements', 'verifies', 'documents', 'supersedes'];
const skipDirs = new Set(['.git', 'node_modules', 'dist', 'coverage', 'docs-html', 'evolution', 'evolutions', 'qa']);
const knownMcpServers = ['filesystem', 'github', 'postgres', 'playwright', 'chrome-devtools'];

const runtimeRegistry = {
  'codex-home': {
    id: 'codex-home',
    displayName: 'Codex home',
    scope: 'home',
    skillsSubdir: 'skills',
    agentsSubdir: 'agents',
    settingsFile: 'config.toml',
    settingsFormat: 'codex-toml',
    codexAgents: true,
  },
  'codex-project': {
    id: 'codex-project',
    displayName: 'Codex project',
    scope: 'project',
    configDir: '.codex',
    skillsSubdir: '.codex/skills',
    agentsSubdir: '.codex/agents',
    settingsFile: '.codex/config.toml',
    settingsFormat: 'codex-toml',
    codexAgents: true,
    managedConfig: true,
  },
  'claude-project': {
    id: 'claude-project',
    displayName: 'Claude project',
    scope: 'project',
    configDir: '.claude',
    skillsSubdir: '.claude/skills',
    agentsSubdir: '.claude/agents',
    settingsFile: '.mcp.json',
    settingsFormat: 'standard-json',
    codexAgents: false,
  },
  'universal-project': {
    id: 'universal-project',
    displayName: 'Universal project',
    scope: 'project',
    configDir: '.agents',
    skillsSubdir: '.agents/skills',
    agentsSubdir: null,
    settingsFile: null,
    settingsFormat: null,
    codexAgents: false,
  },
};

function printHelp() {
  console.log(`ADLC

Usage:
  adlc <command> [args]

Commands:
  help                         Show this help.
  validate                     Run package validation.
  list                         List packaged ADLC skills and Codex agents.
  runtimes                     List supported install runtimes.
  status [target-dir]          Report managed install state.
  install [target-dir]         Install ADLC into a selected runtime.
  update [target-dir]          Refresh selected runtime when safe.
  upgrade                      Print package/self-update guidance.
  mcp <list|configure|remove>  Manage supported MCP server config.
  extension <cmd>              Manage local ADLC extensions.
  resolve-config [target-dir]  Print resolved ADLC config paths.
  workstream <cmd>             Manage ADLC workstream scaffolds and stage state.
  install-codex                Sync packaged skills and agents into local Codex home.
  init [target-dir]            Initialize a target project's .adlc scaffold.
  audit-artifacts [targets...] Audit markdown artifact metadata.

Options:
  --json                       Print audit output as JSON.
  --strict                     Treat warnings as failures in artifact audit.
  --force                      Allow update to overwrite installed drift.
  --runtime <id>               Runtime id. Default: codex-home.
`);
}

function optionValue(args, name, fallback = null) {
  const prefix = `${name}=`;
  const inline = args.find((arg) => arg.startsWith(prefix));
  if (inline) return inline.slice(prefix.length);
  const index = args.indexOf(name);
  if (index >= 0 && index + 1 < args.length) return args[index + 1];
  return fallback;
}

function positionalArgs(args) {
  const result = [];
  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index];
    if (arg.startsWith('--')) {
      if (!arg.includes('=') && index + 1 < args.length && !args[index + 1].startsWith('--')) {
        index += 1;
      }
      continue;
    }
    result.push(arg);
  }
  return result;
}

function runScriptResult(scriptName, args) {
  const scriptPath = path.join(repoRoot, 'scripts', scriptName);
  return spawnSync(scriptPath, args, {
    cwd: repoRoot,
    stdio: 'inherit',
    shell: false,
  });
}

function runScript(scriptName, args) {
  const result = runScriptResult(scriptName, args);

  if (result.error) {
    console.error(result.error.message);
    process.exit(1);
  }

  process.exit(result.status === null ? 1 : result.status);
}

function copyDirectoryFiltered(source, target, shouldSkip) {
  fs.mkdirSync(target, { recursive: true });
  for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
    const sourcePath = path.join(source, entry.name);
    const relPath = path.relative(source, sourcePath).split(path.sep).join('/');
    if (shouldSkip(relPath, entry)) continue;

    const targetPath = path.join(target, entry.name);
    if (entry.isDirectory()) {
      copyDirectoryFiltered(sourcePath, targetPath, (nestedRel, nestedEntry) => {
        const combined = `${relPath}/${nestedRel}`.replace(/^\.\//, '');
        return shouldSkip(combined, nestedEntry);
      });
    } else if (entry.isFile()) {
      fs.mkdirSync(path.dirname(targetPath), { recursive: true });
      fs.copyFileSync(sourcePath, targetPath);
    }
  }
}

function copyManagedArtifact(source, target) {
  fs.rmSync(target, { recursive: true, force: true });
  fs.mkdirSync(path.dirname(target), { recursive: true });
  const stats = fs.statSync(source);
  if (stats.isDirectory()) {
    fs.cpSync(source, target, { recursive: true });
  } else {
    fs.copyFileSync(source, target);
  }
}

function copyManagedPackageArtifact(artifact) {
  if (artifact.kind === 'skill' && fs.statSync(artifact.source).isDirectory()) {
    fs.rmSync(artifact.target, { recursive: true, force: true });
    copyDirectoryFiltered(artifact.source, artifact.target, (relPath, entry) => entry.isDirectory() && relPath === 'tests');
    return;
  }

  copyManagedArtifact(artifact.source, artifact.target);
}

function removeIfSafe(record, force, log) {
  if (!record.target || !fs.existsSync(record.target)) {
    return 'absent';
  }
  const currentHash = hashPath(record.target);
  if (!force && record.installedHash && currentHash !== record.installedHash) {
    log(`Skipped drifted removed artifact: ${record.kind}:${record.name}`);
    return 'skipped-drifted';
  }
  fs.rmSync(record.target, { recursive: true, force: true });
  log(`Removed obsolete managed artifact: ${record.kind}:${record.name}`);
  return 'removed';
}

function codexHome() {
  return process.env.CODEX_HOME || path.join(process.env.HOME || '', '.codex');
}

function resolveRuntime(args, defaultRuntime = 'codex-home') {
  const runtimeId = optionValue(args, '--runtime', defaultRuntime);
  const runtime = runtimeRegistry[runtimeId];
  if (!runtime) {
    throw new Error(`Unknown ADLC runtime: ${runtimeId}. Available: ${Object.keys(runtimeRegistry).join(', ')}`);
  }

  const positionals = positionalArgs(args);
  const targetArg = positionals[0];
  const root = runtime.scope === 'home'
    ? codexHome()
    : path.resolve(process.cwd(), targetArg || '.');

  return {
    ...runtime,
    root,
    skillsDir: path.join(root, runtime.skillsSubdir),
    agentsDir: runtime.agentsSubdir ? path.join(root, runtime.agentsSubdir) : null,
    settingsPath: runtime.settingsFile ? path.join(root, runtime.settingsFile) : null,
    stateFile: runtime.scope === 'home'
      ? path.join(root, 'adlc-managed-state.json')
      : path.join(root, '.adlc', `managed-state.${runtime.id}.json`),
  };
}

function statePath(runtime) {
  return runtime.stateFile;
}

function listFilesRecursive(root) {
  if (!fs.existsSync(root)) return [];
  const result = [];

  function walk(current) {
    const stats = fs.lstatSync(current);
    if (stats.isSymbolicLink()) {
      return;
    }
    if (stats.isFile()) {
      result.push(current);
      return;
    }
    if (!stats.isDirectory()) {
      return;
    }
    for (const entry of fs.readdirSync(current).sort()) {
      walk(path.join(current, entry));
    }
  }

  walk(root);
  return result.sort((a, b) => a.localeCompare(b));
}

function hashPath(targetPath) {
  if (!fs.existsSync(targetPath)) return null;
  const stats = fs.lstatSync(targetPath);
  if (stats.isSymbolicLink()) return null;
  const hasher = crypto.createHash('sha256');

  if (stats.isFile()) {
    hasher.update(fs.readFileSync(targetPath));
    return hasher.digest('hex');
  }

  if (!stats.isDirectory()) return null;

  for (const file of listFilesRecursive(targetPath)) {
    const relPath = path.relative(targetPath, file).split(path.sep).join('/');
    hasher.update(`path:${relPath}\n`);
    hasher.update(fs.readFileSync(file));
    hasher.update('\n');
  }
  return hasher.digest('hex');
}

function stripAdlcMcpBlocks(content) {
  return content.replace(/\n?# BEGIN ADLC MCP [^\n]+\n[\s\S]*?# END ADLC MCP [^\n]+\n?/g, '\n').trimEnd();
}

function hashFileContent(content, relPath = null) {
  const hasher = crypto.createHash('sha256');
  if (relPath) {
    hasher.update(`path:${relPath}\n`);
  }
  hasher.update(content);
  if (relPath) {
    hasher.update('\n');
  }
  return hasher.digest('hex');
}

function hashManagedArtifactPath(artifact, targetPath) {
  if (!fs.existsSync(targetPath)) return null;
  const stats = fs.lstatSync(targetPath);
  if (stats.isSymbolicLink()) return null;

  if (stats.isFile()) {
    const content = fs.readFileSync(targetPath);
    if (artifact.kind === 'config' && artifact.name === 'config.toml') {
      return hashFileContent(stripAdlcMcpBlocks(content.toString('utf8')));
    }
    return hashPath(targetPath);
  }

  if (!stats.isDirectory()) return null;

  if (artifact.kind === 'skill') {
    const hasher = crypto.createHash('sha256');
    const files = listFilesRecursive(targetPath)
      .filter((file) => {
        const relPath = path.relative(targetPath, file).split(path.sep).join('/');
        return relPath !== 'tests' && !relPath.startsWith('tests/');
      });
    if (files.length === 0) return null;
    for (const file of files) {
      const relPath = path.relative(targetPath, file).split(path.sep).join('/');
      hasher.update(`path:${relPath}\n`);
      hasher.update(fs.readFileSync(file));
      hasher.update('\n');
    }
    return hasher.digest('hex');
  }

  return hashPath(targetPath);
}

function managedArtifacts(runtime) {
  const skillsRoot = path.join(repoRoot, 'skills', 'adlc');
  const agentsRoot = path.join(repoRoot, 'subagents', 'codex', 'agents');
  const artifacts = [];

  for (const name of fs.readdirSync(skillsRoot).sort()) {
    const source = path.join(skillsRoot, name);
    if (!fs.statSync(source).isDirectory()) continue;
    if (name !== 'adlc' && !name.startsWith('adlc-')) continue;
    artifacts.push({
      kind: 'skill',
      name,
      source,
      target: path.join(runtime.skillsDir, name),
    });
  }

  if (runtime.codexAgents && runtime.agentsDir) {
    for (const name of fs.readdirSync(agentsRoot).sort()) {
      if (!name.endsWith('.toml')) continue;
      artifacts.push({
        kind: 'agent',
        name,
        source: path.join(agentsRoot, name),
        target: path.join(runtime.agentsDir, name),
      });
    }
  }

  if (runtime.managedConfig && runtime.settingsPath) {
    artifacts.push({
      kind: 'config',
      name: 'config.toml',
      source: path.join(repoRoot, 'subagents', 'codex', 'config.toml'),
      target: runtime.settingsPath,
    });
  }

  return artifacts;
}

function loadManagedState(runtime) {
  const file = statePath(runtime);
  if (!fs.existsSync(file)) {
    return null;
  }
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    return null;
  }
}

function buildManagedState(runtime) {
  const artifacts = {};
  for (const artifact of managedArtifacts(runtime)) {
    artifacts[`${artifact.kind}:${artifact.name}`] = {
      kind: artifact.kind,
      name: artifact.name,
      source: path.relative(repoRoot, artifact.source).split(path.sep).join('/'),
      target: artifact.target,
      sourceHash: hashManagedArtifactPath(artifact, artifact.source),
      installedHash: hashManagedArtifactPath(artifact, artifact.target),
    };
  }

  return {
    schema_version: 1,
    package: '@davidvictor/adlc',
    recorded_at: new Date().toISOString(),
    runtime: runtime.id,
    root: runtime.root,
    artifacts,
  };
}

function writeManagedState(runtime) {
  const file = statePath(runtime);
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const state = buildManagedState(runtime);
  fs.writeFileSync(file, `${JSON.stringify(state, null, 2)}\n`);
  return state;
}

function computeManagedStatus(runtime) {
  const previous = loadManagedState(runtime);
  const current = buildManagedState(runtime);
  const entries = [];

  for (const [key, artifact] of Object.entries(current.artifacts)) {
    const prior = previous && previous.artifacts ? previous.artifacts[key] : null;
    let status = 'unchanged';
    let reason = 'managed artifact matches recorded state';

    if (!artifact.installedHash) {
      status = 'missing';
      reason = 'installed artifact is missing';
    } else if (!prior) {
      status = 'untracked';
      reason = 'no managed state recorded for artifact';
    } else if (prior.installedHash && artifact.installedHash !== prior.installedHash) {
      status = 'drifted';
      reason = 'installed artifact differs from last recorded install';
    } else if (prior.sourceHash && artifact.sourceHash !== prior.sourceHash) {
      status = 'source-changed';
      reason = 'packaged source changed since last recorded install';
    }

    entries.push({
      key,
      kind: artifact.kind,
      name: artifact.name,
      status,
      reason,
      sourceHash: artifact.sourceHash,
      installedHash: artifact.installedHash,
    });
  }

  if (previous && previous.artifacts) {
    for (const [key, artifact] of Object.entries(previous.artifacts)) {
      if (current.artifacts[key]) continue;
      const installedHash = artifact.target ? hashPath(artifact.target) : null;
      entries.push({
        key,
        kind: artifact.kind,
        name: artifact.name,
        status: installedHash && installedHash !== artifact.installedHash ? 'removed-drifted' : 'removed-from-package',
        reason: installedHash
          ? 'artifact is no longer packaged'
          : 'artifact is no longer packaged and is already absent',
        sourceHash: artifact.sourceHash || null,
        installedHash,
        previousInstalledHash: artifact.installedHash || null,
        target: artifact.target,
      });
    }
  }

  return {
    runtime: runtime.id,
    root: runtime.root,
    state_file: statePath(runtime),
    has_state: Boolean(previous),
    entries,
  };
}

function printManagedStatus(args) {
  const json = args.includes('--json');
  const strict = args.includes('--strict');
  const runtime = resolveRuntime(args);
  const status = computeManagedStatus(runtime);
  const counts = status.entries.reduce((acc, entry) => {
    acc[entry.status] = (acc[entry.status] || 0) + 1;
    return acc;
  }, {});
  const blocking = status.entries.some((entry) => ['missing', 'drifted', 'removed-drifted'].includes(entry.status));

  if (json) {
    console.log(JSON.stringify({ ...status, counts, blocking }, null, 2));
  } else {
    console.log(`ADLC runtime: ${runtime.id} (${runtime.displayName})`);
    console.log(`Root: ${runtime.root}`);
    console.log(`ADLC managed state: ${status.has_state ? status.state_file : 'not recorded'}`);
    console.log(`Artifacts: ${status.entries.length}`);
    for (const [name, count] of Object.entries(counts).sort()) {
      console.log(`${name}: ${count}`);
    }
    for (const entry of status.entries.filter((item) => item.status !== 'unchanged')) {
      console.log(`${entry.status.toUpperCase()}: ${entry.kind}:${entry.name} - ${entry.reason}`);
    }
  }

  process.exit(strict && blocking ? 1 : 0);
}

function installRuntime(args, fixedRuntime = null) {
  const runtime = resolveRuntime(fixedRuntime ? [...args, `--runtime=${fixedRuntime}`] : args);
  const force = args.includes('--force');
  const previous = loadManagedState(runtime);
  const currentArtifacts = managedArtifacts(runtime);
  const currentKeys = new Set(currentArtifacts.map((artifact) => `${artifact.kind}:${artifact.name}`));
  const log = (message) => console.log(message);

  for (const artifact of currentArtifacts) {
    copyManagedPackageArtifact(artifact);
    log(`Synced ADLC ${artifact.kind}: ${artifact.target}`);
  }

  if (previous && previous.artifacts) {
    for (const [key, record] of Object.entries(previous.artifacts)) {
      if (currentKeys.has(key)) continue;
      removeIfSafe(record, force, log);
    }
  }

  const state = writeManagedState(runtime);
  console.log(`Recorded managed install state: ${statePath(runtime)}`);
  console.log(`Managed artifacts: ${Object.keys(state.artifacts).length}`);
}

function installCodex(args) {
  installRuntime(args, 'codex-home');
}

function updateRuntime(args, fixedRuntime = null) {
  const runtime = resolveRuntime(fixedRuntime ? [...args, `--runtime=${fixedRuntime}`] : args);
  const force = args.includes('--force');
  const status = computeManagedStatus(runtime);
  const drifted = status.entries.filter((entry) => ['drifted', 'removed-drifted'].includes(entry.status));
  if (drifted.length > 0 && !force) {
    console.error('ADLC update stopped because installed managed artifacts drifted.');
    for (const entry of drifted) {
      console.error(`DRIFTED: ${entry.kind}:${entry.name}`);
    }
    console.error('Review local edits or rerun with --force to overwrite managed artifacts.');
    process.exit(1);
  }

  installRuntime(args.filter((arg) => arg !== '--force'), runtime.id);
}

function updateCodex(args) {
  updateRuntime(args, 'codex-home');
}

function printRuntimes(args) {
  const json = args.includes('--json');
  const runtimes = Object.values(runtimeRegistry).map((runtime) => ({
    id: runtime.id,
    display_name: runtime.displayName,
    scope: runtime.scope,
    supports_agents: Boolean(runtime.codexAgents),
    supports_mcp: Boolean(runtime.settingsFile),
  }));

  if (json) {
    console.log(JSON.stringify({ runtimes }, null, 2));
    return;
  }

  for (const runtime of runtimes) {
    console.log(`${runtime.id}\t${runtime.display_name}\tagents=${runtime.supports_agents}\tmcp=${runtime.supports_mcp}`);
  }
}

function printUpgradeGuidance() {
  console.log('ADLC upgrade guidance');
  console.log('');
  console.log('ADLC is currently private and intentionally not published to NPM.');
  console.log('Update the package source with git, then refresh installed runtime artifacts:');
  console.log('');
  console.log('  git pull');
  console.log('  node bin/adlc.js update --runtime codex-home');
  console.log('');
  console.log('When ADLC becomes publishable, this command should become the package self-update entrypoint.');
}

function parseScalar(value) {
  const trimmed = stripQuotes(stripInlineComment(value).trim());
  if (trimmed === 'true') return true;
  if (trimmed === 'false') return false;
  if (/^-?\d+$/.test(trimmed)) return Number(trimmed);
  return trimmed;
}

function parseSimpleSections(content) {
  const result = {};
  let section = null;

  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.replace(/\s+$/, '');
    if (!line.trim() || line.trimStart().startsWith('#')) continue;

    const sectionMatch = line.match(/^([A-Za-z0-9_-]+):\s*$/);
    if (sectionMatch) {
      section = sectionMatch[1];
      result[section] = result[section] || {};
      continue;
    }

    const keyValueMatch = line.match(/^  ([A-Za-z0-9_-]+):\s*(.*)$/);
    if (section && keyValueMatch) {
      result[section][keyValueMatch[1]] = parseScalar(keyValueMatch[2]);
    }
  }

  return result;
}

function mergeConfig(base, override) {
  const merged = { ...base };
  for (const [section, values] of Object.entries(override)) {
    merged[section] = { ...(merged[section] || {}), ...values };
  }
  return merged;
}

function loadAdlcConfig(targetDir) {
  const templatePath = path.join(repoRoot, 'templates', 'adlc', 'config.yaml');
  const targetConfigPath = path.join(targetDir, '.adlc', 'config.yaml');
  const templateConfig = parseSimpleSections(fs.readFileSync(templatePath, 'utf8'));
  const targetConfig = fs.existsSync(targetConfigPath)
    ? parseSimpleSections(fs.readFileSync(targetConfigPath, 'utf8'))
    : {};

  return {
    configPath: targetConfigPath,
    configExists: fs.existsSync(targetConfigPath),
    config: mergeConfig(templateConfig, targetConfig),
  };
}

function resolveConfig(args) {
  const json = args.includes('--json');
  const targetArg = args.find((arg) => !arg.startsWith('--'));
  const targetDir = path.resolve(process.cwd(), targetArg || '.');
  const loaded = loadAdlcConfig(targetDir);
  const paths = {};

  for (const [key, value] of Object.entries(loaded.config.paths || {})) {
    if (typeof value !== 'string') continue;
    paths[key] = {
      relative: value,
      absolute: path.resolve(targetDir, value),
    };
  }

  const result = {
    project_dir: targetDir,
    config_file: loaded.configPath,
    config_exists: loaded.configExists,
    workflow: loaded.config.workflow || {},
    git: loaded.config.git || {},
    paths,
  };

  if (json) {
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  console.log(`ADLC config: ${result.config_exists ? result.config_file : 'template defaults'}`);
  console.log(`Project: ${result.project_dir}`);
  for (const [key, value] of Object.entries(paths)) {
    console.log(`${key}: ${value.relative} -> ${value.absolute}`);
  }
}

function workstreamHelp() {
  console.log(`ADLC workstream

Usage:
  adlc workstream create <slug> [target-dir] [--title <title>] [--executor codex|hermes|either]
  adlc workstream status <slug> [target-dir] [--json]
  adlc workstream advance <slug> <step-id> [target-dir] --stage ready|build|review|test|commit|done|blocked

Workstreams live under configured paths.workstreams, defaulting to .adlc/workstreams.
`);
}

function slugify(value) {
  return String(value || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-{2,}/g, '-');
}

function titleizeSlug(slug) {
  return slug
    .split('-')
    .filter(Boolean)
    .map((part) => `${part[0].toUpperCase()}${part.slice(1)}`)
    .join(' ');
}

function renderTemplate(content, values) {
  return content.replace(/\{\{([A-Z0-9_]+)\}\}/g, (_, key) => values[key] || '');
}

function workstreamsDirFor(targetDir) {
  const loaded = loadAdlcConfig(targetDir);
  const configured = loaded.config.paths && loaded.config.paths.workstreams
    ? loaded.config.paths.workstreams
    : '.adlc/workstreams';
  return path.resolve(targetDir, configured);
}

function writeFileIfMissing(filePath, content) {
  if (fs.existsSync(filePath)) return false;
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, content);
  return true;
}

function readWorkstreamTemplate(name) {
  const templatePath = path.join(repoRoot, 'skills', 'adlc', 'adlc-workstream', 'templates', name);
  return fs.readFileSync(templatePath, 'utf8');
}

function stageStatus(stage) {
  if (stage === 'done') return 'done';
  if (stage === 'blocked') return 'blocked';
  return 'active';
}

function workstreamRoot(targetDir, slug) {
  return path.join(workstreamsDirFor(targetDir), slug);
}

function createWorkstream(args) {
  const positionals = positionalArgs(args);
  const rawSlug = positionals[0];
  if (!rawSlug) {
    throw new Error('Usage: adlc workstream create <slug> [target-dir]');
  }

  const slug = slugify(rawSlug);
  if (!slug) {
    throw new Error(`Invalid workstream slug: ${rawSlug}`);
  }

  const targetDir = path.resolve(process.cwd(), positionals[1] || '.');
  const title = optionValue(args, '--title', titleizeSlug(slug));
  const executor = optionValue(args, '--executor', 'either');
  if (!['codex', 'hermes', 'either'].includes(executor)) {
    throw new Error('Workstream executor must be codex, hermes, or either.');
  }

  const root = workstreamRoot(targetDir, slug);
  const workstreamId = `adlc-workstream-${slug}`;
  const stepId = `${workstreamId}-0001`;
  const values = {
    WORKSTREAM_ID: workstreamId,
    TITLE: title,
    STEP_ID: stepId,
    STEP_TITLE: 'Define First Executable Step',
  };
  const created = [];

  fs.mkdirSync(path.join(root, 'steps'), { recursive: true });
  fs.mkdirSync(path.join(root, 'handoff'), { recursive: true });

  if (writeFileIfMissing(path.join(root, 'WORKSTREAM.md'), renderTemplate(readWorkstreamTemplate('WORKSTREAM.md'), values))) {
    created.push('WORKSTREAM.md');
  }

  const kanban = `---\nid: ${workstreamId}-kanban\ntype: kanban\nstatus: active\nowner: ADLC\ndocuments: [${workstreamId}]\n---\n\n# ${title} Kanban\n\n| Stage | Steps |\n| --- | --- |\n| ready | ${stepId} |\n| build |  |\n| review |  |\n| test |  |\n| commit |  |\n| done |  |\n| blocked |  |\n`;
  if (writeFileIfMissing(path.join(root, 'kanban.md'), kanban)) {
    created.push('kanban.md');
  }

  const evidence = `---\nid: ${workstreamId}-evidence\ntype: evidence\nstatus: active\nowner: ADLC\ndocuments: [${workstreamId}]\n---\n\n# ${title} Evidence\n\nCapture source files, docs, runtime output, user decisions, and constraints that justify each step.\n`;
  if (writeFileIfMissing(path.join(root, 'evidence.md'), evidence)) {
    created.push('evidence.md');
  }

  const stepContent = renderTemplate(readWorkstreamTemplate('STEP.md'), values).replace('executor: either', `executor: ${executor}`);
  if (writeFileIfMissing(path.join(root, 'steps', '0001-define-first-executable-step.md'), stepContent)) {
    created.push('steps/0001-define-first-executable-step.md');
  }

  if (writeFileIfMissing(path.join(root, 'handoff', 'codex.md'), renderTemplate(readWorkstreamTemplate('CODEX-HANDOFF.md'), values))) {
    created.push('handoff/codex.md');
  }
  if (writeFileIfMissing(path.join(root, 'handoff', 'hermes.md'), renderTemplate(readWorkstreamTemplate('HERMES-HANDOFF.md'), values))) {
    created.push('handoff/hermes.md');
  }

  console.log(`ADLC workstream: ${root}`);
  console.log(`Workstream id: ${workstreamId}`);
  console.log(`Executor lane: ${executor}`);
  console.log(`Created files: ${created.length ? created.join(', ') : 'none; existing scaffold preserved'}`);
}

function listWorkstreamSteps(root, projectDir) {
  const stepsDir = path.join(root, 'steps');
  if (!fs.existsSync(stepsDir)) return [];

  return fs.readdirSync(stepsDir)
    .filter((entry) => entry.endsWith('.md'))
    .sort()
    .map((entry) => {
      const absPath = path.join(stepsDir, entry);
      const content = fs.readFileSync(absPath, 'utf8');
      const fields = parseFrontmatter(content) || {};
      return {
        file: normalizeRelPath(projectDir, absPath),
        id: first(fields, 'id') || entry.replace(/\.md$/, ''),
        stage: first(fields, 'stage') || 'unknown',
        status: first(fields, 'status') || 'unknown',
        executor: first(fields, 'executor') || 'unknown',
        depends_on: fields.depends_on || [],
      };
    });
}

function statusWorkstream(args) {
  const json = args.includes('--json');
  const positionals = positionalArgs(args);
  const rawSlug = positionals[0];
  if (!rawSlug) {
    throw new Error('Usage: adlc workstream status <slug> [target-dir]');
  }

  const slug = slugify(rawSlug);
  const targetDir = path.resolve(process.cwd(), positionals[1] || '.');
  const root = workstreamRoot(targetDir, slug);
  if (!fs.existsSync(root)) {
    throw new Error(`Workstream does not exist: ${root}`);
  }

  const steps = listWorkstreamSteps(root, targetDir);
  const byStage = {};
  for (const step of steps) {
    byStage[step.stage] = (byStage[step.stage] || 0) + 1;
  }

  const result = {
    slug,
    root,
    steps,
    stages: byStage,
  };

  if (json) {
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  console.log(`ADLC workstream: ${root}`);
  console.log(`Steps: ${steps.length}`);
  for (const stage of ['ready', 'build', 'review', 'test', 'commit', 'done', 'blocked', 'unknown']) {
    if (byStage[stage]) {
      console.log(`${stage}: ${byStage[stage]}`);
    }
  }
  for (const step of steps) {
    console.log(`${step.id}\t${step.stage}\t${step.executor}\t${step.file}`);
  }
}

function updateFrontmatterField(content, key, value) {
  if (!content.startsWith('---\n') && !content.startsWith('---\r\n')) {
    throw new Error('Step file is missing frontmatter.');
  }
  const endMatch = content.match(/\r?\n---\r?\n/);
  if (!endMatch || typeof endMatch.index !== 'number') {
    throw new Error('Step file has unterminated frontmatter.');
  }

  const endIndex = endMatch.index;
  const frontmatter = content.slice(0, endIndex);
  const rest = content.slice(endIndex);
  const fieldPattern = new RegExp(`^${key}:.*$`, 'm');
  if (fieldPattern.test(frontmatter)) {
    return `${frontmatter.replace(fieldPattern, `${key}: ${value}`)}${rest}`;
  }
  return `${frontmatter}\n${key}: ${value}${rest}`;
}

function advanceWorkstream(args) {
  const positionals = positionalArgs(args);
  const rawSlug = positionals[0];
  const stepSelector = positionals[1];
  if (!rawSlug || !stepSelector) {
    throw new Error('Usage: adlc workstream advance <slug> <step-id> [target-dir] --stage <stage>');
  }

  const stage = optionValue(args, '--stage');
  const allowedStages = ['ready', 'build', 'review', 'test', 'commit', 'done', 'blocked'];
  if (!allowedStages.includes(stage)) {
    throw new Error(`Stage must be one of: ${allowedStages.join(', ')}`);
  }

  const slug = slugify(rawSlug);
  const targetDir = path.resolve(process.cwd(), positionals[2] || '.');
  const root = workstreamRoot(targetDir, slug);
  if (!fs.existsSync(root)) {
    throw new Error(`Workstream does not exist: ${root}`);
  }

  const steps = listWorkstreamSteps(root, targetDir);
  const matches = steps.filter((step) => (
    step.id === stepSelector ||
    step.id.endsWith(`-${stepSelector}`) ||
    path.basename(step.file).startsWith(stepSelector)
  ));
  if (matches.length !== 1) {
    throw new Error(`Expected one matching step for ${stepSelector}, found ${matches.length}.`);
  }

  const stepPath = path.resolve(targetDir, matches[0].file);
  let content = fs.readFileSync(stepPath, 'utf8');
  content = updateFrontmatterField(content, 'stage', stage);
  content = updateFrontmatterField(content, 'status', stageStatus(stage));
  fs.writeFileSync(stepPath, content);

  console.log(`Advanced ${matches[0].id} to ${stage}`);
  console.log(matches[0].file);
}

function handleWorkstream(args) {
  const [subcommand = 'help', ...subArgs] = args;
  switch (subcommand) {
    case 'help':
    case '--help':
    case '-h':
      workstreamHelp();
      break;
    case 'create':
      createWorkstream(subArgs);
      break;
    case 'status':
      statusWorkstream(subArgs);
      break;
    case 'advance':
      advanceWorkstream(subArgs);
      break;
    default:
      throw new Error(`Unknown workstream command: ${subcommand}`);
  }
}

function loadMcpTemplate(key) {
  const templatePath = path.join(repoRoot, 'mcp', 'templates', `${key}.json`);
  if (!fs.existsSync(templatePath)) {
    throw new Error(`Unknown MCP server: ${key}. Available: ${knownMcpServers.join(', ')}`);
  }
  const template = JSON.parse(fs.readFileSync(templatePath, 'utf8'));
  if (!template.command || typeof template.command !== 'string') {
    throw new Error(`MCP template ${key} is missing command.`);
  }
  if (template.args && (!Array.isArray(template.args) || template.args.some((arg) => typeof arg !== 'string'))) {
    throw new Error(`MCP template ${key} args must be strings.`);
  }
  return template;
}

function jsString(value) {
  return JSON.stringify(value);
}

function tomlArray(values) {
  return `[${(values || []).map((value) => jsString(value)).join(', ')}]`;
}

function removeMcpTomlBlock(content, key) {
  const escaped = key.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const pattern = new RegExp(`\\n?# BEGIN ADLC MCP ${escaped}\\n[\\s\\S]*?# END ADLC MCP ${escaped}\\n?`, 'g');
  return content.replace(pattern, '\n').trimEnd();
}

function renderMcpTomlBlock(key, template) {
  const lines = [
    `# BEGIN ADLC MCP ${key}`,
    `[mcp_servers.${key}]`,
    `command = ${jsString(template.command)}`,
  ];
  if (template.args && template.args.length > 0) {
    lines.push(`args = ${tomlArray(template.args)}`);
  }
  if (template.env && Object.keys(template.env).length > 0) {
    lines.push(`[mcp_servers.${key}.env]`);
    for (const [envKey, value] of Object.entries(template.env)) {
      lines.push(`${envKey} = ${jsString(value)}`);
    }
  }
  lines.push(`# END ADLC MCP ${key}`);
  return lines.join('\n');
}

function configureMcpToml(runtime, keys, remove = false) {
  if (!runtime.settingsPath) {
    throw new Error(`Runtime ${runtime.id} does not support MCP settings.`);
  }
  fs.mkdirSync(path.dirname(runtime.settingsPath), { recursive: true });
  if (runtime.managedConfig && !fs.existsSync(runtime.settingsPath)) {
    const sourceConfig = path.join(repoRoot, 'subagents', 'codex', 'config.toml');
    fs.copyFileSync(sourceConfig, runtime.settingsPath);
  }
  let content = fs.existsSync(runtime.settingsPath) ? fs.readFileSync(runtime.settingsPath, 'utf8') : '';
  for (const key of keys) {
    content = removeMcpTomlBlock(content, key);
    if (!remove) {
      content = `${content.trimEnd()}\n\n${renderMcpTomlBlock(key, loadMcpTemplate(key))}\n`;
    }
  }
  fs.writeFileSync(runtime.settingsPath, content.trimStart());
}

function configureMcpJson(runtime, keys, remove = false) {
  if (!runtime.settingsPath) {
    throw new Error(`Runtime ${runtime.id} does not support MCP settings.`);
  }
  fs.mkdirSync(path.dirname(runtime.settingsPath), { recursive: true });
  let settings = {};
  if (fs.existsSync(runtime.settingsPath)) {
    try {
      settings = JSON.parse(fs.readFileSync(runtime.settingsPath, 'utf8'));
    } catch {
      settings = {};
    }
  }
  settings.mcpServers = settings.mcpServers && typeof settings.mcpServers === 'object' ? settings.mcpServers : {};
  for (const key of keys) {
    if (remove) {
      delete settings.mcpServers[key];
    } else {
      settings.mcpServers[key] = loadMcpTemplate(key);
    }
  }
  fs.writeFileSync(runtime.settingsPath, `${JSON.stringify(settings, null, 2)}\n`);
}

function parseMcpKeys(args) {
  const positionals = positionalArgs(args);
  const command = positionals[0] || 'list';
  const rawKeys = positionals.slice(1).filter((arg) => knownMcpServers.includes(arg) || arg === 'all');
  const keys = rawKeys.includes('all') ? knownMcpServers : rawKeys;
  return { command, keys };
}

function handleMcp(args) {
  const { command, keys } = parseMcpKeys(args);
  const json = args.includes('--json');

  if (command === 'list') {
    const servers = knownMcpServers.map((key) => ({ key, template: loadMcpTemplate(key) }));
    if (json) {
      console.log(JSON.stringify({ servers }, null, 2));
    } else {
      for (const server of servers) {
        console.log(`${server.key}\t${server.template.command} ${(server.template.args || []).join(' ')}`.trim());
      }
    }
    return;
  }

  if (!['configure', 'remove'].includes(command)) {
    throw new Error('MCP command must be one of: list, configure, remove');
  }
  if (keys.length === 0) {
    throw new Error(`MCP ${command} requires one or more server keys, or "all".`);
  }

  const runtimeArgs = args.filter((arg) => !knownMcpServers.includes(arg) && arg !== 'all' && arg !== command);
  const runtime = resolveRuntime(runtimeArgs);
  if (!runtime.settingsPath) {
    throw new Error(`Runtime ${runtime.id} does not support MCP settings.`);
  }

  if (runtime.settingsFormat === 'codex-toml') {
    configureMcpToml(runtime, keys, command === 'remove');
  } else {
    configureMcpJson(runtime, keys, command === 'remove');
  }

  console.log(`${command === 'remove' ? 'Removed' : 'Configured'} MCP servers for ${runtime.id}: ${keys.join(', ')}`);
  console.log(`Settings: ${runtime.settingsPath}`);
}

function extensionRegistryPath(projectDir) {
  return path.join(projectDir, '.adlc', 'extensions', 'registry.json');
}

function loadExtensionRegistry(projectDir) {
  const file = extensionRegistryPath(projectDir);
  if (!fs.existsSync(file)) {
    return { schema_version: 1, extensions: [] };
  }
  try {
    const parsed = JSON.parse(fs.readFileSync(file, 'utf8'));
    return {
      schema_version: 1,
      extensions: Array.isArray(parsed.extensions) ? parsed.extensions : [],
    };
  } catch {
    return { schema_version: 1, extensions: [] };
  }
}

function writeExtensionRegistry(projectDir, registry) {
  const file = extensionRegistryPath(projectDir);
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
}

function assertInside(baseDir, candidate) {
  const relative = path.relative(baseDir, candidate);
  if (relative.startsWith('..') || path.isAbsolute(relative)) {
    throw new Error(`Path escapes extension boundary: ${candidate}`);
  }
}

function loadExtensionManifest(sourceDir) {
  const manifestPath = path.join(sourceDir, 'extension.json');
  if (!fs.existsSync(manifestPath)) {
    throw new Error(`Extension manifest not found: ${manifestPath}`);
  }
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  if (!manifest.name || typeof manifest.name !== 'string') {
    throw new Error('Extension manifest requires string name.');
  }
  if (!manifest.version || typeof manifest.version !== 'string') {
    throw new Error('Extension manifest requires string version.');
  }
  for (const skillPath of manifest.skills || []) {
    const abs = path.resolve(sourceDir, skillPath);
    assertInside(sourceDir, abs);
    if (!fs.existsSync(path.join(abs, 'SKILL.md'))) {
      throw new Error(`Extension skill missing SKILL.md: ${skillPath}`);
    }
  }
  for (const agentFile of manifest.agentFiles || []) {
    const abs = path.resolve(sourceDir, agentFile.source || '');
    assertInside(sourceDir, abs);
    if (!agentFile.runtime || !agentFile.source || !agentFile.target || !fs.existsSync(abs)) {
      throw new Error('Extension agentFiles entries require runtime, source, target, and an existing source file.');
    }
  }
  for (const server of manifest.mcpServers || []) {
    if (!server.key || !server.template) {
      throw new Error('Extension mcpServers entries require key and template.');
    }
  }
  for (const injection of manifest.injections || []) {
    const abs = path.resolve(sourceDir, injection.file || '');
    assertInside(sourceDir, abs);
    if (!injection.target || !['append', 'prepend'].includes(injection.position) || !injection.file || !fs.existsSync(abs)) {
      throw new Error('Extension injections entries require target, append/prepend position, and an existing file.');
    }
  }
  for (const [skillPath, baseSkillName] of Object.entries(manifest.replaces || {})) {
    const abs = path.resolve(sourceDir, skillPath);
    assertInside(sourceDir, abs);
    if (!baseSkillName || !fs.existsSync(path.join(abs, 'SKILL.md'))) {
      throw new Error(`Extension replacement requires a skill directory and base skill name: ${skillPath}`);
    }
  }
  return manifest;
}

function extensionProjectDir(args) {
  const positionals = positionalArgs(args);
  const command = positionals[0] || 'list';
  if (command === 'add') return path.resolve(process.cwd(), positionals[2] || '.');
  if (command === 'remove') return path.resolve(process.cwd(), positionals[2] || '.');
  if (command === 'validate') return process.cwd();
  return path.resolve(process.cwd(), positionals[1] || '.');
}

function extensionInstallDir(projectDir, name) {
  return path.join(projectDir, '.adlc', 'extensions', name);
}

function readExtensionMcpTemplate(extensionDir, server) {
  if (typeof server.template === 'string') {
    const templatePath = path.resolve(extensionDir, server.template);
    assertInside(extensionDir, templatePath);
    return JSON.parse(fs.readFileSync(templatePath, 'utf8'));
  }
  return server.template;
}

function extensionMarker(name, target, position, side) {
  return `<!-- adlc-ext:${name}:${target}:${position}:${side} -->`;
}

function stripExtensionInjection(content, name, target, position) {
  const start = extensionMarker(name, target, position, 'start').replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const end = extensionMarker(name, target, position, 'end').replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return content.replace(new RegExp(`\\n?${start}\\n[\\s\\S]*?\\n${end}\\n?`, 'g'), '\n').trimEnd();
}

function stripAllExtensionInjections(content, name) {
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return content.replace(new RegExp(`\\n?<!-- adlc-ext:${escaped}:[^:]+:[^:]+:start -->\\n[\\s\\S]*?\\n<!-- adlc-ext:${escaped}:[^:]+:[^:]+:end -->\\n?`, 'g'), '\n').trimEnd();
}

function applyExtensionInjection(skillContent, injectionContent, name, target, position) {
  let content = stripExtensionInjection(skillContent, name, target, position);
  const block = [
    extensionMarker(name, target, position, 'start'),
    injectionContent.trimEnd(),
    extensionMarker(name, target, position, 'end'),
  ].join('\n');

  if (position === 'prepend') {
    const frontmatter = content.match(/^---\n[\s\S]*?\n---\n/);
    if (frontmatter) {
      return `${content.slice(0, frontmatter[0].length)}\n${block}\n${content.slice(frontmatter[0].length)}`;
    }
    return `${block}\n\n${content}`;
  }

  return `${content.trimEnd()}\n\n${block}\n`;
}

function skillFilePath(runtime, skillName) {
  return path.join(runtime.skillsDir, skillName, 'SKILL.md');
}

function applyExtensionInjections(runtime, extensionDir, manifest) {
  const installedInjections = [];
  for (const injection of manifest.injections || []) {
    const targetFile = skillFilePath(runtime, injection.target);
    if (!fs.existsSync(targetFile)) continue;
    const injectionFile = path.resolve(extensionDir, injection.file);
    assertInside(extensionDir, injectionFile);
    const current = fs.readFileSync(targetFile, 'utf8');
    const next = applyExtensionInjection(
      current,
      fs.readFileSync(injectionFile, 'utf8'),
      manifest.name,
      injection.target,
      injection.position,
    );
    fs.writeFileSync(targetFile, next);
    installedInjections.push({
      target: injection.target,
      position: injection.position,
      file: targetFile,
      installedHash: hashPath(targetFile),
    });
  }
  return installedInjections;
}

function stripInstalledExtensionInjections(runtime, record) {
  const seen = new Set();
  for (const injection of record.installedInjections || []) {
    if (!injection.file || seen.has(injection.file) || !fs.existsSync(injection.file)) continue;
    seen.add(injection.file);
    const current = fs.readFileSync(injection.file, 'utf8');
    const next = stripAllExtensionInjections(current, record.name);
    if (next !== current.trimEnd()) {
      fs.writeFileSync(injection.file, `${next}\n`);
    }
  }

  if (runtime.skillsDir && fs.existsSync(runtime.skillsDir)) {
    for (const file of listFilesRecursive(runtime.skillsDir).filter((item) => item.endsWith('SKILL.md'))) {
      if (seen.has(file)) continue;
      const current = fs.readFileSync(file, 'utf8');
      if (!current.includes(`adlc-ext:${record.name}:`)) continue;
      const next = stripAllExtensionInjections(current, record.name);
      fs.writeFileSync(file, `${next}\n`);
    }
  }
}

function removeExtensionMcp(runtime, keys) {
  if (!runtime.settingsPath || keys.length === 0) return;
  if (runtime.settingsFormat === 'codex-toml') {
    configureMcpToml(runtime, keys, true);
  } else {
    configureMcpJson(runtime, keys, true);
  }
}

function installExtension(args) {
  const positionals = positionalArgs(args);
  const sourceArg = positionals[1];
  if (!sourceArg) throw new Error('extension add requires a local source directory.');
  const sourceDir = path.resolve(process.cwd(), sourceArg);
  const projectDir = extensionProjectDir(args);
  const runtime = resolveRuntime([projectDir, `--runtime=${optionValue(args, '--runtime', 'codex-project')}`]);
  const manifest = loadExtensionManifest(sourceDir);
  const extensionDir = extensionInstallDir(projectDir, manifest.name);
  const registry = loadExtensionRegistry(projectDir);
  const existingIndex = registry.extensions.findIndex((entry) => entry.name === manifest.name);
  const installedSkills = [];
  const installedAgentFiles = [];
  const installedMcpServers = [];
  const installedReplacements = [];

  fs.rmSync(extensionDir, { recursive: true, force: true });
  fs.mkdirSync(path.dirname(extensionDir), { recursive: true });
  fs.cpSync(sourceDir, extensionDir, { recursive: true });

  const replacementPaths = new Set(Object.keys(manifest.replaces || {}));
  for (const skillPath of manifest.skills || []) {
    if (replacementPaths.has(skillPath)) continue;
    const sourceSkill = path.resolve(extensionDir, skillPath);
    const skillName = path.basename(sourceSkill);
    const target = path.join(runtime.skillsDir, skillName);
    copyManagedArtifact(sourceSkill, target);
    installedSkills.push({ name: skillName, target, installedHash: hashPath(target) });
  }

  for (const [skillPath, baseSkillName] of Object.entries(manifest.replaces || {})) {
    const sourceSkill = path.resolve(extensionDir, skillPath);
    const target = path.join(runtime.skillsDir, baseSkillName);
    copyManagedArtifact(sourceSkill, target);
    installedReplacements.push({ name: baseSkillName, target, installedHash: hashPath(target) });
  }

  for (const agentFile of manifest.agentFiles || []) {
    if (agentFile.runtime !== runtime.id) continue;
    if (!runtime.agentsDir) continue;
    const sourceFile = path.resolve(extensionDir, agentFile.source);
    const target = path.join(runtime.agentsDir, agentFile.target);
    copyManagedArtifact(sourceFile, target);
    installedAgentFiles.push({ target, installedHash: hashPath(target) });
  }

  for (const server of manifest.mcpServers || []) {
    if (!runtime.settingsPath) continue;
    const template = readExtensionMcpTemplate(extensionDir, server);
    if (runtime.settingsFormat === 'codex-toml') {
      fs.mkdirSync(path.dirname(runtime.settingsPath), { recursive: true });
      let content = fs.existsSync(runtime.settingsPath) ? fs.readFileSync(runtime.settingsPath, 'utf8') : '';
      content = removeMcpTomlBlock(content, server.key);
      content = `${content.trimEnd()}\n\n${renderMcpTomlBlock(server.key, template)}\n`;
      fs.writeFileSync(runtime.settingsPath, content.trimStart());
    } else {
      fs.mkdirSync(path.dirname(runtime.settingsPath), { recursive: true });
      let settings = {};
      if (fs.existsSync(runtime.settingsPath)) {
        try { settings = JSON.parse(fs.readFileSync(runtime.settingsPath, 'utf8')); } catch { settings = {}; }
      }
      settings.mcpServers = settings.mcpServers && typeof settings.mcpServers === 'object' ? settings.mcpServers : {};
      settings.mcpServers[server.key] = template;
      fs.writeFileSync(runtime.settingsPath, `${JSON.stringify(settings, null, 2)}\n`);
    }
    installedMcpServers.push(server.key);
  }

  const installedInjections = applyExtensionInjections(runtime, extensionDir, manifest);

  const record = {
    name: manifest.name,
    version: manifest.version,
    source: sourceDir,
    runtime: runtime.id,
    installed_at: new Date().toISOString(),
    installedSkills,
    installedReplacements,
    installedAgentFiles,
    installedMcpServers,
    installedInjections,
  };
  if (existingIndex >= 0) registry.extensions[existingIndex] = record;
  else registry.extensions.push(record);
  writeExtensionRegistry(projectDir, registry);

  console.log(`Installed ADLC extension ${manifest.name}@${manifest.version}`);
  console.log(`Project registry: ${extensionRegistryPath(projectDir)}`);
}

function removeExtension(args) {
  const positionals = positionalArgs(args);
  const name = positionals[1];
  if (!name) throw new Error('extension remove requires an extension name.');
  const projectDir = extensionProjectDir(args);
  const force = args.includes('--force');
  const registry = loadExtensionRegistry(projectDir);
  const index = registry.extensions.findIndex((entry) => entry.name === name);
  if (index < 0) throw new Error(`Extension is not installed: ${name}`);
  const record = registry.extensions[index];
  const log = (message) => console.log(message);
  const runtime = resolveRuntime([projectDir, `--runtime=${record.runtime || optionValue(args, '--runtime', 'codex-project')}`]);

  stripInstalledExtensionInjections(runtime, record);

  for (const replacement of record.installedReplacements || []) {
    const status = removeIfSafe({ kind: 'extension-replacement', name: replacement.name, target: replacement.target, installedHash: replacement.installedHash }, force, log);
    const packagedSource = path.join(repoRoot, 'skills', 'adlc', replacement.name);
    if (status !== 'skipped-drifted' && fs.existsSync(packagedSource)) {
      copyManagedPackageArtifact({ kind: 'skill', name: replacement.name, source: packagedSource, target: replacement.target });
      log(`Restored ADLC skill: ${replacement.name}`);
    }
  }

  for (const skill of record.installedSkills || []) {
    removeIfSafe({ kind: 'extension-skill', name: skill.name, target: skill.target, installedHash: skill.installedHash }, force, log);
  }
  for (const agentFile of record.installedAgentFiles || []) {
    removeIfSafe({ kind: 'extension-agent', name: path.basename(agentFile.target), target: agentFile.target, installedHash: agentFile.installedHash }, force, log);
  }
  removeExtensionMcp(runtime, record.installedMcpServers || []);

  fs.rmSync(extensionInstallDir(projectDir, name), { recursive: true, force: true });
  registry.extensions.splice(index, 1);
  writeExtensionRegistry(projectDir, registry);
  console.log(`Removed ADLC extension ${name}`);
}

function handleExtension(args) {
  const positionals = positionalArgs(args);
  const command = positionals[0] || 'list';
  const json = args.includes('--json');

  if (command === 'validate') {
    const sourceArg = positionals[1];
    if (!sourceArg) throw new Error('extension validate requires a local source directory.');
    const sourceDir = path.resolve(process.cwd(), sourceArg);
    const manifest = loadExtensionManifest(sourceDir);
    if (json) console.log(JSON.stringify({ status: 'pass', manifest }, null, 2));
    else console.log(`Extension valid: ${manifest.name}@${manifest.version}`);
    return;
  }

  if (command === 'add') {
    installExtension(args);
    return;
  }

  if (command === 'remove') {
    removeExtension(args);
    return;
  }

  if (command !== 'list') {
    throw new Error('Extension command must be one of: list, validate, add, remove');
  }

  const projectDir = extensionProjectDir(args);
  const registry = loadExtensionRegistry(projectDir);
  if (json) {
    console.log(JSON.stringify({ project_dir: projectDir, ...registry }, null, 2));
    return;
  }
  if (registry.extensions.length === 0) {
    console.log('No ADLC extensions installed.');
    return;
  }
  for (const extension of registry.extensions) {
    console.log(`${extension.name}\t${extension.version}\t${extension.runtime}`);
  }
}

function normalizeRelPath(projectDir, filePath) {
  return path.relative(projectDir, filePath).split(path.sep).join('/');
}

function isInsideProject(projectDir, candidate) {
  const relative = path.relative(projectDir, candidate);
  return relative === '' || (!relative.startsWith('..') && !path.isAbsolute(relative));
}

function stripInlineComment(value) {
  const hashIndex = value.indexOf(' #');
  return hashIndex >= 0 ? value.slice(0, hashIndex).trim() : value.trim();
}

function stripQuotes(value) {
  const trimmed = stripInlineComment(value).trim();
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1).trim();
  }
  return trimmed;
}

function parseArrayValue(value) {
  const trimmed = stripInlineComment(value).trim();
  if (!trimmed) return [];

  if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
    return trimmed
      .slice(1, -1)
      .split(',')
      .map((item) => stripQuotes(item))
      .filter(Boolean);
  }

  return [stripQuotes(trimmed)].filter(Boolean);
}

function parseFrontmatter(content) {
  if (!content.startsWith('---\n') && !content.startsWith('---\r\n')) {
    return null;
  }

  const endMatch = content.match(/\r?\n---\r?\n/);
  if (!endMatch || typeof endMatch.index !== 'number') {
    return null;
  }

  const block = content.slice(content.indexOf('\n') + 1, endMatch.index);
  const fields = {};
  let currentListKey = null;

  for (const rawLine of block.split(/\r?\n/)) {
    const line = rawLine.trimEnd();
    if (!line.trim() || line.trimStart().startsWith('#')) {
      continue;
    }

    const listMatch = line.match(/^\s*-\s+(.+)$/);
    if (listMatch && currentListKey) {
      fields[currentListKey] = [
        ...(fields[currentListKey] || []),
        ...parseArrayValue(listMatch[1]),
      ];
      continue;
    }

    const fieldMatch = line.match(/^([A-Za-z0-9_.-]+):(?:\s*(.*))?$/);
    if (!fieldMatch) {
      currentListKey = null;
      continue;
    }

    const key = fieldMatch[1];
    const value = fieldMatch[2] || '';
    currentListKey = value.trim() === '' ? key : null;
    fields[key] = parseArrayValue(value);
  }

  return fields;
}

function collectMarkdownFiles(projectDir, targets, explicitTargets) {
  const files = new Set();
  const findings = [];
  const visited = new Set();
  const canonicalProjectDir = fs.realpathSync(projectDir);

  function addFinding(level, file, message) {
    findings.push({ level, file, message });
  }

  function walk(currentPath, requestedPath, isRootTarget) {
    let canonicalPath;
    try {
      canonicalPath = fs.realpathSync(currentPath);
    } catch {
      addFinding(explicitTargets ? 'fail' : 'warn', requestedPath, `Requested audit target does not exist: ${requestedPath}`);
      return;
    }

    if (!isInsideProject(canonicalProjectDir, canonicalPath)) {
      addFinding(explicitTargets ? 'fail' : 'warn', requestedPath, `Requested audit target is outside the project boundary: ${requestedPath}`);
      return;
    }

    const stats = fs.lstatSync(currentPath);
    const targetStats = stats.isSymbolicLink() ? fs.statSync(canonicalPath) : stats;
    const statTarget = stats.isSymbolicLink() ? canonicalPath : currentPath;

    if (targetStats.isFile()) {
      if (statTarget.endsWith('.md')) {
        files.add(statTarget);
      }
      return;
    }

    if (!targetStats.isDirectory()) {
      return;
    }

    if (visited.has(canonicalPath)) {
      return;
    }
    visited.add(canonicalPath);

    const directoryName = path.basename(currentPath);
    if (!isRootTarget && skipDirs.has(directoryName)) {
      return;
    }

    for (const entry of fs.readdirSync(canonicalPath, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
      walk(path.join(canonicalPath, entry.name), `${requestedPath}/${entry.name}`.replace(/\\/g, '/'), false);
    }
  }

  for (const target of targets) {
    const absTarget = path.resolve(projectDir, target);
    if (!isInsideProject(canonicalProjectDir, absTarget)) {
      addFinding(explicitTargets ? 'fail' : 'warn', target, `Requested audit target is outside the project boundary: ${target}`);
      continue;
    }
    if (!fs.existsSync(absTarget)) {
      if (explicitTargets) {
        addFinding('fail', target, `Requested audit target does not exist: ${target}`);
      }
      continue;
    }
    walk(absTarget, target, true);
  }

  return {
    files: Array.from(files).sort((a, b) => a.localeCompare(b)),
    findings,
  };
}

function first(fields, key) {
  return fields[key] && fields[key][0] ? fields[key][0] : undefined;
}

function toArtifact(projectDir, absPath, fields) {
  const id = first(fields, 'id');
  if (!id) return null;

  const relations = {};
  for (const field of relationFields) {
    relations[field] = fields[field] || [];
  }

  return {
    id,
    file: normalizeRelPath(projectDir, absPath),
    type: first(fields, 'type'),
    status: first(fields, 'status'),
    owners: [...(fields.owners || []), ...(fields.owner || [])].filter(Boolean),
    relations,
  };
}

function relationTargets(artifact) {
  return relationFields.flatMap((field) => artifact.relations[field]);
}

function auditArtifacts(args) {
  const json = args.includes('--json');
  const strict = args.includes('--strict');
  const targets = args.filter((arg) => !arg.startsWith('--'));
  const explicitTargets = targets.length > 0;
  const projectDir = process.cwd();
  const scanTargets = explicitTargets ? targets : defaultAuditTargets;
  const collected = collectMarkdownFiles(projectDir, scanTargets, explicitTargets);
  const findings = [...collected.findings];
  const artifacts = [];
  const byId = new Map();

  for (const file of collected.files) {
    const content = fs.readFileSync(file, 'utf8');
    const fields = parseFrontmatter(content);
    if (!fields) {
      continue;
    }

    const artifact = toArtifact(projectDir, file, fields);
    if (!artifact) {
      findings.push({
        level: 'warn',
        file: normalizeRelPath(projectDir, file),
        message: 'Frontmatter exists but no artifact id was found.',
      });
      continue;
    }

    artifacts.push(artifact);
    if (!byId.has(artifact.id)) {
      byId.set(artifact.id, []);
    }
    byId.get(artifact.id).push(artifact);
  }

  for (const artifact of artifacts) {
    if (!artifact.type) {
      findings.push({ level: 'warn', file: artifact.file, id: artifact.id, message: 'Artifact is missing type.' });
    }
    if (!artifact.status) {
      findings.push({ level: 'warn', file: artifact.file, id: artifact.id, message: 'Artifact is missing status.' });
    }
    if (artifact.owners.length === 0) {
      findings.push({ level: 'warn', file: artifact.file, id: artifact.id, message: 'Artifact is missing owner or owners.' });
    }

    for (const target of relationTargets(artifact)) {
      if (!byId.has(target)) {
        findings.push({
          level: 'fail',
          file: artifact.file,
          id: artifact.id,
          message: `Artifact references missing id: ${target}`,
        });
      }
    }
  }

  for (const [id, records] of byId.entries()) {
    if (records.length > 1) {
      for (const record of records) {
        findings.push({
          level: 'fail',
          file: record.file,
          id,
          message: `Duplicate artifact id appears ${records.length} times.`,
        });
      }
    }
  }

  const failCount = findings.filter((finding) => finding.level === 'fail').length;
  const warnCount = findings.filter((finding) => finding.level === 'warn').length;
  const shouldFail = failCount > 0 || (strict && warnCount > 0);
  const result = {
    status: shouldFail ? 'fail' : 'pass',
    strict,
    scanned_files: collected.files.map((file) => normalizeRelPath(projectDir, file)),
    artifacts,
    findings,
  };

  if (json) {
    console.log(JSON.stringify(result, null, 2));
  } else {
    console.log(`ADLC artifact audit: ${result.status}`);
    console.log(`Scanned markdown files: ${result.scanned_files.length}`);
    console.log(`Artifacts with ids: ${artifacts.length}`);
    console.log(`Findings: ${failCount} fail, ${warnCount} warn`);
    for (const finding of findings) {
      const id = finding.id ? ` [${finding.id}]` : '';
      const file = finding.file ? `${finding.file}: ` : '';
      console.log(`${finding.level.toUpperCase()}: ${file}${finding.message}${id}`);
    }
  }

  process.exit(shouldFail ? 1 : 0);
}

const [command = 'help', ...args] = process.argv.slice(2);

switch (command) {
  case 'help':
  case '--help':
  case '-h':
    printHelp();
    break;
  case 'validate':
    runScript('validate-adlc.sh', args);
    break;
  case 'list':
    runScript('list-adlc.sh', args);
    break;
  case 'runtimes':
    printRuntimes(args);
    break;
  case 'status':
    printManagedStatus(args);
    break;
  case 'install':
    installRuntime(args);
    break;
  case 'update':
    updateRuntime(args);
    break;
  case 'upgrade':
    printUpgradeGuidance();
    break;
  case 'mcp':
    handleMcp(args);
    break;
  case 'extension':
    handleExtension(args);
    break;
  case 'resolve-config':
    resolveConfig(args);
    break;
  case 'workstream':
    handleWorkstream(args);
    break;
  case 'install-codex':
    installCodex(args);
    break;
  case 'init':
    runScript('init-adlc-project.sh', args);
    break;
  case 'audit-artifacts':
    auditArtifacts(args);
    break;
  default:
    console.error(`Unknown ADLC command: ${command}`);
    printHelp();
    process.exit(1);
}
