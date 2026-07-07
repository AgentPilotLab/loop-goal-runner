# Comparison and Originality Notes

Current star counts were checked on 2026-07-07.

| Project | Stars | Main focus | Difference from Loop Goal Runner |
| --- | ---: | --- | --- |
| [Jcapathy/loop-goal-skills](https://github.com/Jcapathy/loop-goal-skills) | 1 | Claude/Cowork-oriented `/loop` and `/goal` skills using `LOOP_STATE.md` and `wiki/`. | Loop Goal Runner is Codex-first, smaller, and centered on goal-scoped `STATE.md`, objective gates, stop rules, subagent judgment, and worktree judgment. |
| [FlexNetOS/harness_hub](https://github.com/FlexNetOS/harness_hub) | 0 | Continuous backlog loop for a specific Feature Forge/handoff stack. | Loop Goal Runner is a general skill contract rather than a stack-specific backlog runner. |
| [FlexNetOS/lane](https://github.com/FlexNetOS/lane) | 0 | Verification loop for a specific Rust lane workflow. | Loop Goal Runner is reusable across arbitrary Codex and Claude Code goals. |

## Originality Audit

On 2026-07-07, a local text-similarity check compared the local Loop Goal Runner skill files against `Jcapathy/loop-goal-skills` core files:

- `README.md`
- `goal/SKILL.md`
- `loop/SKILL.md`
- `loop/references/state-schema.md`

Results:

- 8-word shingle overlap: 0
- 7-word shingle overlap: 0
- 6-word shingle overlap: 0
- exact nontrivial line overlap longer than 45 characters: 0
- 4-5 word overlap limited to generic skill language such as "use when the user"

This repository should still avoid copying external README structure, benchmark language, hook text, skill prose, or branding. Public references should be phrased as inspiration, comparison, or industry context rather than endorsement.
