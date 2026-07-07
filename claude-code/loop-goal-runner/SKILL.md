---
name: loop-goal-runner
description: Run Claude Code goals and long-running tasks as loop-engineered workflows with STATE.md memory, objective gates, stop conditions, and optional maker/checker subagents. Use when the user mentions /goal, Goal mode, loop engineering, loop-style execution, stateful automation, recurring agent work, "continue until done", "verify before completion", or asks Claude Code to preserve progress across turns or runs.
allowed-tools: Read Write Edit MultiEdit Glob Grep LS Bash TodoWrite
---

# Loop Goal Runner

Use this skill to turn an open-ended Claude Code task into a small, stateful loop. The loop must have a clear goal, durable state, an objective gate, and a stop rule. Keep the default path lightweight; add subagents or worktrees only when the task justifies the extra cost.

## Core Contract

Every loop run must maintain these four artifacts or decisions:

1. **Goal**: the current user objective and completion criteria.
2. **State**: a durable `STATE.md` file or an explicitly named external state system.
3. **Gate**: tests, lint, type checks, build, data validation, screenshot checks, or another objective proof command.
4. **Stop rule**: success, blocker, max attempts, max runtime, budget limit, or human approval boundary.

Do not claim completion without fresh verification evidence. If there is no objective gate, keep the work in advisory/manual mode and say that it is not a good loop candidate.

## Workflow

### 1. Run the Loop Fit Check

Before building or continuing a loop, check whether the task is suitable:

- Repeats at least weekly, or is long enough that persistent state matters.
- Has an objective gate that can reject bad output.
- Can be executed in the available environment.
- Has a hard stop condition.
- Does not require unsupervised judgment for architecture, auth, payments, production deploys, or irreversible actions.

If one of these fails, explain the failed condition and use a normal one-shot workflow unless the user explicitly asks to proceed.

### 2. Locate or Create State

Treat state as goal-scoped by default. Every distinct goal should have its own durable state file unless the user explicitly asks to reuse an existing state file or the existing file clearly belongs to the same active goal.

State path precedence:

1. Use the exact state file path named by the user, if any.
2. If continuing an existing goal and its prior state path is known, reuse that same file.
3. If the goal creates or primarily modifies one task repository or artifact directory, use that task root's `STATE.md`.
4. Otherwise create a goal-specific file under `.codex/goals/<goal-slug>/STATE.md` in the current workspace, or `.claude/goals/<goal-slug>/STATE.md` if the project already uses Claude-specific state folders.
5. Use the workspace root `STATE.md` only when the workspace itself is the goal, or when the user explicitly selects it.

Before reusing any existing `STATE.md`, inspect its Goal and Current Status sections. If they describe a different objective, do not overwrite or repurpose it. Create a new goal-scoped state file instead and mention the separation briefly.

If the selected state file does not exist and file edits are allowed, create it from the state template in this repository. If edits are not allowed, draft the initial state in the response and ask the user to place it.

At the start of every loop run:

- Read the selected goal-scoped state file before planning.
- Read the nearest applicable `AGENTS.md`, `CLAUDE.md`, or equivalent project instructions when available.
- Extract the last run, current status, open blockers, next actions, verification history, lessons learned, and the state file path.

At the end of every loop run:

- Update only the selected goal-scoped state file with the actual actions taken.
- Record verification commands and outcomes.
- Record the next action or stop reason.
- Preserve lessons that should survive compaction or future runs.
- Do not move, archive, or rewrite an unrelated goal's state unless the user explicitly asks.

### 3. Shape the Goal

Write the goal so it is measurable:

```text
/goal <objective>. Done when: <objective gate passes>. Constraints: update the selected goal-scoped state file each run; stop after <N> failed attempts or when human judgment is needed.
```

If a goal is already active, use the current goal as the source of truth unless the user changes it. If no goal is active, infer a working goal from the user request and state it briefly.

### 4. Execute One Loop Iteration

Use this iteration shape:

1. Read state and instructions.
2. Choose the next smallest useful action.
3. Execute the action.
4. Run the relevant gate or explain why it cannot run.
5. Review the diff or output.
6. Update the selected goal-scoped state file.
7. Decide continue, stop, or escalate.

Keep changes scoped. Prefer one reliable manual run before scheduling automation.

### 5. Decide Whether to Use Subagents

Default to a single agent. Use subagents only when at least one applies:

- Independent investigations can run in parallel.
- A maker/checker split would materially reduce risk.
- The task has several unrelated failures, subsystems, or documents.
- The user explicitly asks for parallel agents or subagents.

When using subagents, apply these patterns:

- **Maker/checker**: one agent implements or investigates, another reviews spec compliance and code quality.
- **Parallel dispatch**: one agent per independent problem domain.
- **Verifier**: a fresh agent reviews evidence, not hidden reasoning.

Do not treat a subagent opinion as a hard gate. Objective verification still wins.

### 6. Decide Whether to Use Worktrees

Use worktrees for code changes when multiple agents or long-running branches may write concurrently. Skip worktrees for read-only research, document analysis, small one-file edits, or non-repo workspaces.

If worktrees are needed, prefer the runtime's native worktree support when available. Otherwise, use Git worktrees only after confirming the target repo and ensuring the worktree directory will not be committed accidentally.

### 7. Completion and Escalation

Stop and report clearly when:

- The gate passes and the goal criteria are met.
- The max attempts, runtime, or budget limit is reached.
- Required permissions, credentials, external services, or human judgment are needed.
- The same blocker repeats across three consecutive loop turns.
- The loop would need to touch architecture, auth, payments, production deploys, secrets, or broad permissions without explicit human approval.

The final response must include the current state, verification evidence, and next recommended action.
