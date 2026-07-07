# AI Agent Guide

This guide is for Codex, Claude Code, and other AI agents that need to install, inspect, or use Loop Goal Runner.

## Install Surfaces

Codex:

```powershell
Copy-Item -Recurse .\skills\loop-goal-runner "$env:USERPROFILE\.codex\skills\loop-goal-runner"
```

Claude Code:

```bash
mkdir -p .claude/skills
cp -R claude-code/loop-goal-runner .claude/skills/loop-goal-runner
```

## Invocation Pattern

Use this shape when a user asks for a long-running or autonomous goal:

```text
/goal <objective>
Done when: <objective gate passes>
Constraints: update the selected goal-scoped STATE.md each run; stop after <N> failed attempts or when human judgment is needed.
```

## State Selection

Select state in this order:

1. Exact state file path named by the user.
2. Known prior state path for the same active goal.
3. Task repository or artifact root `STATE.md`.
4. `.codex/goals/<goal-slug>/STATE.md` in the current workspace.
5. Workspace root `STATE.md` only when the workspace itself is the goal or the user explicitly selects it.

Before reusing an existing `STATE.md`, inspect its goal and current status. If it belongs to another objective, create a new goal-scoped state file.

## One Iteration

1. Read the selected state file and relevant project instructions.
2. Choose the next smallest useful action.
3. Execute the action.
4. Run the verification gate or explain why it cannot run.
5. Review the output or diff.
6. Update the selected state file.
7. Decide whether to continue, stop, or escalate.

## Completion Rule

Do not claim completion unless a fresh objective gate passed. If there is no objective gate, keep the work advisory or manual and say why it is not a good loop candidate.

## Human Approval Boundaries

Stop before:

- credentials, tokens, cookies, OAuth flows, or private account changes;
- irreversible or destructive operations;
- production deploys;
- payment or billing changes;
- broad permission changes;
- legal, medical, financial, or other high-stakes judgment;
- repeated blockers across three loop turns.
