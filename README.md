# Loop Goal Runner: Stateful Goal Mode Skill for Codex, Claude Code, and AI Agents

<a href="https://buymeacoffee.com/mira.ai">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy me a coffee" width="180">
</a>

[中文README](README.zh-CN.md)

Loop Goal Runner is an AI agent skill for Codex, Claude Code, and other skill-capable coding agents that need to run `/goal`, Goal mode, long-running tasks, recurring agent work, or "continue until done" requests as a bounded, stateful, verifiable loop.

Use this repository when an agent needs four things before it can safely keep working across turns or sessions:

- a clear goal with measurable completion criteria;
- a durable `STATE.md` memory file scoped to the current goal;
- an objective gate such as tests, lint, typecheck, build, data validation, screenshot checks, or another explicit proof command;
- a stop rule for success, blockers, max attempts, budget limits, credentials, external services, or human approval boundaries.

This is not a generic productivity prompt. It is a compact loop specification for agentic coding workflows where "done" requires fresh evidence.

## Agent Use Cases

- Turn a vague `/goal` request into a measurable objective with a gate and stop condition.
- Resume a long-running Codex or Claude Code task from a goal-scoped `STATE.md`.
- Keep future agent runs from overwriting unrelated project or workspace state.
- Require fresh verification evidence before an agent claims completion.
- Decide when maker/checker subagents or isolated worktrees are worth the token and coordination cost.
- Stop safely when the loop reaches a human judgment boundary, permission boundary, repeated blocker, or risky production action.

## Quick Start

Codex user-level install:

```powershell
Copy-Item -Recurse .\skills\loop-goal-runner "$env:USERPROFILE\.codex\skills\loop-goal-runner"
```

Claude Code project-level install:

```bash
mkdir -p .claude/skills
cp -R claude-code/loop-goal-runner .claude/skills/loop-goal-runner
```

Sanity check the repository before publishing or vendoring:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

Minimal invocation:

```text
/goal Improve the project until the test suite passes.
Done when: the relevant test command exits 0.
Constraints: update the selected goal-scoped STATE.md each run; stop after 3 failed attempts or when human approval is needed.
```

## Tool Surface

Loop Goal Runner provides file-based agent instructions, not a network service.

| Surface | Path | Purpose |
| --- | --- | --- |
| Codex skill | `skills/loop-goal-runner/SKILL.md` | Main skill for Codex Goal mode and stateful loop execution. |
| Codex agent metadata | `skills/loop-goal-runner/agents/openai.yaml` | Display metadata for Codex-compatible skill loaders. |
| Claude Code skill | `claude-code/loop-goal-runner/SKILL.md` | Claude Code-compatible skill copy with the same loop contract. |
| State template | `skills/loop-goal-runner/references/state-template.md` | Minimal durable `STATE.md` schema for new goals. |
| AGENTS snippet | `skills/loop-goal-runner/references/agents-snippet.md` | Optional trigger reliability snippet for project instructions. |
| Agent guide | `docs/AI_AGENT_GUIDE.md` | Operational guide for AI agents installing or using the skill. |
| Validation script | `scripts/validate-repo.ps1` | Checks public docs for required files and obvious private-path leaks. |

## Why This Loop Is Different

Many agent loops fail because they are just repeated prompting. Loop Goal Runner treats the loop as a durable operating contract:

- **Goal-scoped state by default.** It avoids the common mistake of reusing a workspace-level `STATE.md` for unrelated objectives.
- **Gate before completion.** It does not let an agent call a task complete without fresh verification evidence.
- **Stop conditions are first-class.** The skill names success, blockers, repeated failure, budget limits, credentials, external services, production actions, and human judgment as explicit terminal states.
- **Subagents are opt-in.** Maker/checker and parallel investigation patterns are allowed when useful, but the default path stays single-agent and lightweight.
- **Worktrees are conditional.** It uses worktrees for concurrent code writes, not for every small document or one-file change.
- **Codex and Claude Code are both documented.** The same loop contract can be installed into Codex or Claude Code skill surfaces without pretending the two runtimes are identical.

## Industry Context

Loop Goal Runner is aligned with a broader shift from one-off prompting toward durable agent workflows. These references are provided as industry context, not as endorsements of this repository.

- Andrej Karpathy's Software 2.0 framing moved programming toward specifying desired behavior and iterating through feedback, rather than hand-authoring every instruction. His later "vibe coding" framing made the natural-language `say -> generate -> run -> observe -> fix` loop highly visible, while also warning that this style is best suited to low-risk or throwaway projects without stronger controls. Sources: [Software 2.0 overview](https://es.wikipedia.org/wiki/Software_2.0), [vibe coding overview](https://en.wikipedia.org/wiki/Vibe_coding), [Tom's Guide on vibe coding](https://www.tomsguide.com/ai/vibe-coding).
- Boris Cherny, creator of Claude Code, has been reported as describing a move away from writing every prompt by hand and toward loops where agents prompt and coordinate other Claude instances. Business Insider describes `/goal` as a loop pattern for tools such as Claude Code and Codex: the agent keeps working until the task is complete. Source: [Business Insider on loop engineering](https://www.businessinsider.com/what-are-loops-ai-engineering-tips-2026-6).
- Addy Osmani's public loop-engineering commentary, as summarized by Business Insider, emphasizes automations, worktrees, skills, plugins/connectors, and subagents. Loop Goal Runner keeps those ingredients but adds a conservative default: state, gate, and stop rule first. Source: [Business Insider on loop engineering](https://www.businessinsider.com/what-are-loops-ai-engineering-tips-2026-6).
- Dario Amodei and Anthropic have emphasized that more autonomous models require more careful measurement and oversight. The Guardian reported Amodei's concern that as models can act on their own, developers must ask whether they are doing what users actually want. Source: [The Guardian on Anthropic and autonomous AI risk](https://www.theguardian.com/technology/2025/nov/17/ai-firms-risks-tobacco-anthropic-artificial-intelligence-dario-amodei).

## Similar Projects

Current star counts were checked on 2026-07-07.

| Project | Stars | Strength | Loop Goal Runner difference | Recommendation index |
| --- | ---: | --- | --- | ---: |
| [Jcapathy/loop-goal-skills](https://github.com/Jcapathy/loop-goal-skills) | 1 | Claude/Cowork-oriented `/loop` and `/goal` skills with `LOOP_STATE.md` plus `wiki/`. | This repo is Codex-first, goal-scoped, smaller, and centered on `STATE.md`, objective gates, stop rules, subagent judgment, and worktree judgment. | 7/10 |
| [FlexNetOS/harness_hub](https://github.com/FlexNetOS/harness_hub) | 0 | Rich continuous backlog loop for a specific Feature Forge/handoff stack. | This repo is runtime-neutral and intentionally avoids coupling to a private backlog/kernel system. | 3/10 |
| [FlexNetOS/lane](https://github.com/FlexNetOS/lane) | 0 | Strong verification loop for a specific Rust lane workflow. | This repo is a reusable skill contract for arbitrary Codex and Claude Code goals, not a single-project runner. | 2/10 |

Originality note: a local text-similarity audit compared this repository's skill text against `Jcapathy/loop-goal-skills` on 2026-07-07. It found no 6-word, 7-word, or 8-word shingle overlap, and no exact nontrivial line overlap longer than 45 characters. The overlap at 4-5 words was limited to generic skill phrasing such as "use when the user."

## Codex Setup

Install the skill into a Codex user skill directory:

```powershell
Copy-Item -Recurse .\skills\loop-goal-runner "$env:USERPROFILE\.codex\skills\loop-goal-runner"
```

Then start a fresh Codex session and invoke:

```text
/goal <objective>. Done when: <objective gate passes>. Constraints: update the selected goal-scoped state file each run; stop after <N> failed attempts or when human judgment is needed.
```

Optional trigger reliability: copy `skills/loop-goal-runner/references/agents-snippet.md` into a project or global `AGENTS.md` that your Codex runtime reads.

## Claude Code Setup

Claude Code status: **supported as a skill copy**, with the same file-based loop contract. This repository does not ship a Claude-only CLI runner.

Project-level install:

```bash
mkdir -p .claude/skills
cp -R claude-code/loop-goal-runner .claude/skills/loop-goal-runner
```

Use the same `/goal` shape:

```text
/goal <objective>
Done when: <test, build, lint, eval, or validation gate passes>
Stop: success, blocker, max attempts, budget limit, credential boundary, or human approval boundary
```

## Security and Privacy

- Do not store tokens, cookies, OAuth credentials, SSH keys, `.env` files, local browser profiles, or machine-specific absolute paths in `STATE.md`.
- Use placeholders such as `<PROJECT_DIR>`, `<USER_HOME>`, `example.com`, and `your-token-here`.
- Treat destructive commands, production deploys, auth changes, payments, broad permission changes, and external account operations as human approval boundaries.
- Run `scripts/validate-repo.ps1` before publishing or vendoring this repository.

## License

This repository uses the `AgentPilotLab Non-Commercial License`.

Free use is limited to non-commercial personal use, learning, research, evaluation, and non-revenue projects. Commercial use requires prior written permission from `AgentPilotLab` and payment of the agreed commercial license fee. See [LICENSE](LICENSE).

## AI Entry Points

- `llms.txt` for compact repository routing.
- `AGENTS.md` for public agent instructions.
- `docs/AI_AGENT_GUIDE.md` for operational usage.
- `skills/loop-goal-runner/SKILL.md` for Codex.
- `claude-code/loop-goal-runner/SKILL.md` for Claude Code.
- `scripts/validate-repo.ps1` for local verification.

## Support

Optional support is available through BuyMeACoffee:

<a href="https://buymeacoffee.com/mira.ai">
  <img src="docs/assets/buy-me-a-coffee-qr.jpg" alt="Buy me a coffee QR code" width="180">
</a>

Support link: <https://buymeacoffee.com/mira.ai>
