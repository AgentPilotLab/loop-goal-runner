param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'

$required = @(
  'README.md',
  'README.zh-CN.md',
  'LICENSE',
  'AGENTS.md',
  'llms.txt',
  'docs/AI_AGENT_GUIDE.md',
  'docs/COMPARISON.md',
  'docs/SOURCES.md',
  'skills/loop-goal-runner/SKILL.md',
  'skills/loop-goal-runner/references/state-template.md',
  'skills/loop-goal-runner/references/agents-snippet.md',
  'skills/loop-goal-runner/agents/openai.yaml',
  'claude-code/loop-goal-runner/SKILL.md'
)

$failed = $false

foreach ($rel in $required) {
  $path = Join-Path $Root $rel
  if (-not (Test-Path -LiteralPath $path)) {
    Write-Error "Missing required file: $rel"
    $failed = $true
  }
}

$readme = Get-Content -LiteralPath (Join-Path $Root 'README.md') -Encoding UTF8 -Raw
if ($readme -notmatch 'README\.zh-CN\.md') {
  Write-Error 'README.md must link to README.zh-CN.md near the top.'
  $failed = $true
}

foreach ($requiredPhrase in @('Distribution Status', 'Codex Setup', 'Claude Code Setup', 'GitHub Release', 'AI Entry Points', 'Support')) {
  if ($readme -notmatch [regex]::Escape($requiredPhrase)) {
    Write-Error "README.md must include section or phrase: $requiredPhrase"
    $failed = $true
  }
}

$zhReadme = Get-Content -LiteralPath (Join-Path $Root 'README.zh-CN.md') -Encoding UTF8 -Raw
if ($zhReadme -notmatch 'README\.md') {
  Write-Error 'README.zh-CN.md must link back to README.md near the top.'
  $failed = $true
}

$license = Get-Content -LiteralPath (Join-Path $Root 'LICENSE') -Encoding UTF8 -Raw
if ($license -notmatch 'AgentPilotLab Non-Commercial License') {
  Write-Error 'LICENSE must use AgentPilotLab Non-Commercial License.'
  $failed = $true
}

$textFiles = Get-ChildItem -LiteralPath $Root -Recurse -File |
  Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -ne $PSCommandPath -and
    $_.Extension -in @('.md', '.txt', '.yaml', '.yml', '.json', '.ps1')
  }

$privacyPatterns = @(
  ('C:' + '\\Users\\'),
  '/Users/',
  '/home/',
  'BEGIN RSA PRIVATE KEY',
  'BEGIN OPENSSH PRIVATE KEY',
  'ghp_[A-Za-z0-9_]+',
  'github_pat_[A-Za-z0-9_]+',
  'sk-[A-Za-z0-9_-]{20,}',
  'xox[baprs]-[A-Za-z0-9-]+'
)

foreach ($file in $textFiles) {
  $content = Get-Content -LiteralPath $file.FullName -Encoding UTF8 -Raw
  foreach ($pattern in $privacyPatterns) {
    if ($content -match $pattern) {
      $rel = Resolve-Path -LiteralPath $file.FullName -Relative
      Write-Error "Potential private data pattern '$pattern' in $rel"
      $failed = $true
    }
  }
}

if ($failed) {
  exit 1
}

Write-Host 'Loop Goal Runner repository validation passed.'
