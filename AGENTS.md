# Agent Instructions for Loop Goal Runner

This repository packages `loop-goal-runner`, a stateful Goal mode skill for Codex, Claude Code, and AI agents.

## When To Use This Repository

Use this repository when an agent needs to run `/goal`, Goal mode, recurring work, stateful long-running execution, or "continue until done" tasks with durable memory and objective verification.

## Core Contract

- Read `skills/loop-goal-runner/SKILL.md` before changing the Codex skill.
- Read `claude-code/loop-goal-runner/SKILL.md` before changing the Claude Code skill.
- Keep the Codex and Claude Code copies behaviorally aligned unless a runtime-specific difference is documented.
- Keep `STATE.md` goal-scoped in examples. Do not encourage unrelated goals to share state.
- Never claim completion in docs or examples without a concrete gate such as tests, lint, typecheck, build, data validation, or an explicit manual verification step.
- Treat credentials, external services, destructive actions, production deploys, auth changes, and payments as human approval boundaries.

## Public Documentation Rules

- The default README is English.
- Keep a link to `README.zh-CN.md` near the top of `README.md`.
- Keep a link back to `README.md` near the top of `README.zh-CN.md`.
- Do not add real local machine paths, personal usernames, personal emails, tokens, cookies, OAuth credentials, browser profile paths, screenshots, logs, snapshots, or `.env` files.
- Use placeholders such as `<PROJECT_DIR>`, `<USER_HOME>`, `example.com`, and `your-token-here`.
- When citing public figures or external projects, phrase them as industry context or references, not endorsements.

## Validation

Before publishing or handing this repository to another agent, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

Fix any reported privacy or packaging issue before release.
