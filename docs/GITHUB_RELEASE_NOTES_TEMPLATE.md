# GitHub Release Notes Template

Use this template only when creating a real version on GitHub Releases for `AgentPilotLab/loop-goal-runner`.

Release title format:

```text
Loop Goal Runner vX.Y.Z: Stateful Goal Mode Skill for Codex, Claude Code, and AI Agents
```

## What Changed

- Summarize the user-visible skill, documentation, validation, or packaging changes.
- Keep claims tied to repository evidence, not benchmark promises.

## Install or Upgrade

Source-tree install is the current supported channel:

```powershell
Copy-Item -Recurse .\skills\loop-goal-runner "$env:USERPROFILE\.codex\skills\loop-goal-runner"
```

```bash
mkdir -p .claude/skills
cp -R claude-code/loop-goal-runner .claude/skills/loop-goal-runner
```

If this release includes downloadable assets, list each asset, its purpose, and its checksum.

## Codex Setup

- Supported status: supported as a Codex skill copy.
- Entry file: `skills/loop-goal-runner/SKILL.md`.
- Verification command:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

## Claude Code Setup

- Supported status: supported as a Claude Code skill copy.
- Entry file: `claude-code/loop-goal-runner/SKILL.md`.
- Difference from Codex: no Claude-only CLI runner is shipped unless the release explicitly says otherwise.

## Verification

Before publishing the release, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

Record the command output and any asset checksums in the release notes.

## Privacy and License

- License: `AgentPilotLab Non-Commercial License`.
- Free use is limited to non-commercial use. Commercial use requires prior written permission from `AgentPilotLab`.
- Do not attach files containing local paths, logs, caches, snapshots, `.env` files, credentials, account identifiers, or private working artifacts.
- Scan release notes, asset names, and asset contents before publishing.

## Support

Optional support link: <https://buymeacoffee.com/mira.ai>

Mention support only when it is naturally relevant. Support is optional and is not required for installation, verification, or basic use.
