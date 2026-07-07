## Loop Goal Runner

- When the user starts, mentions, edits, or asks about `/goal`, Goal mode, loop engineering, recurring agent work, or stateful long-running execution, use the `loop-goal-runner` skill if available.
- For goal-like work, first read or create `STATE.md`, then use it to plan the next iteration.
- Do not claim completion without fresh verification evidence from an objective gate such as tests, lint, type checks, build, data validation, or an equivalent explicit check.
- Update `STATE.md` after each loop iteration with actions taken, verification results, blockers, lessons learned, and next actions.
- Use subagents and worktrees only when the task benefits from parallelism, maker/checker separation, or isolated code changes.
