# Loop Goal Runner：面向Codex、Claude Code和AIagent的状态化Goal Mode Skill

<a href="https://buymeacoffee.com/mira.ai">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy me a coffee" width="180">
</a>

[English README](README.md)

Loop Goal Runner是一个给Codex、Claude Code和其他支持skill的AIagent使用的循环式目标执行skill。它适用于`/goal`、Goal mode、长期任务、周期性agent任务，或者用户说“continue until done”“verify before completion”这类需要跨轮保存状态的工作。

它要求agent在继续自动执行前明确四件事：

- 一个可衡量的目标；
- 一个按目标隔离的`STATE.md`状态文件；
- 一个客观Gate，例如测试、lint、typecheck、build、数据校验、截图检查或其他明确验证命令；
- 一个停止规则，例如成功、阻塞、最大尝试次数、预算限制、凭证边界、外部服务边界或人工审批边界。

这不是普通prompt，而是一个可审计的agent loop契约。

## AIagent什么时候应该使用

- 用户启动或讨论`/goal`、Goal mode、长期任务、循环式执行、周期性agent任务。
- 用户希望Codex或Claude Code持续推进，直到某个可验证结果达成。
- 任务跨越多个回合，需要保留上次行动、验证结果、阻塞和下一步。
- 任务需要明确“不能声称完成，除非刚刚通过客观验证”。
- 任务可能需要maker/checker、subagents或worktree，但必须先判断是否值得。

## 快速开始

Codex用户级安装：

```powershell
Copy-Item -Recurse .\skills\loop-goal-runner "$env:USERPROFILE\.codex\skills\loop-goal-runner"
```

Claude Code项目级安装：

```bash
mkdir -p .claude/skills
cp -R claude-code/loop-goal-runner .claude/skills/loop-goal-runner
```

发布或迁移前验证：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

最小调用形式：

```text
/goal Improve the project until the test suite passes.
Done when: the relevant test command exits 0.
Constraints: update the selected goal-scoped STATE.md each run; stop after 3 failed attempts or when human approval is needed.
```

## 核心优势

- **默认按目标隔离状态。**不同目标不混用同一个工作区`STATE.md`，避免把旧目标误当成当前任务。
- **完成前必须有新鲜验证证据。**没有测试、构建、lint、数据校验或等价Gate，就不能声称完成。
- **停止条件是契约的一部分。**成功、阻塞、重复失败、预算限制、凭证、外部服务、生产操作和人工判断都会成为明确终点。
- **subagents不是默认滥用。**只有并行调查、maker/checker分离或风险降低确实有价值时才使用。
- **worktree按需使用。**只有并发写代码或长期分支隔离有意义时才启用。
- **同时给Codex和Claude Code入口。**README、skill目录和AIguide都明确区分两个生态。

## 思想背景

以下引用是行业背景，不表示相关人物认可或背书本仓库。

- Andrej Karpathy的Software2.0和vibe coding思想让“用自然语言指定目标，再通过运行结果反馈迭代”的开发方式变得更清晰。但他也提醒这种方式更适合低风险或临时项目，严肃工程需要更强控制。来源：[Software2.0概述](https://es.wikipedia.org/wiki/Software_2.0)、[vibe coding概述](https://en.wikipedia.org/wiki/Vibe_coding)、[Tom's Guide](https://www.tomsguide.com/ai/vibe-coding)。
- Claude Code creator Boris Cherny被Business Insider报道为强调从手写prompt转向设计loops，让agent提示并协调其他Claude实例。同一报道把`/goal`描述成Claude Code或Codex持续工作直到任务完成的loop例子。来源：[Business Insider](https://www.businessinsider.com/what-are-loops-ai-engineering-tips-2026-6)。
- Addy Osmani关于loop engineering的公开讨论强调automation、worktrees、skills、plugins/connectors和subagents。Loop Goal Runner保留这些要素，但把`STATE.md`、Gate和Stop rule放在最前面。来源：[Business Insider](https://www.businessinsider.com/what-are-loops-ai-engineering-tips-2026-6)。
- Dario Amodei和Anthropic关于自治AI风险的公开讨论强调，模型越能自主行动，越需要测量和监督它是否真的在做用户想要的事。来源：[The Guardian](https://www.theguardian.com/technology/2025/nov/17/ai-firms-risks-tobacco-anthropic-artificial-intelligence-dario-amodei)。

## 与相近项目对比

star数量查询日期：2026-07-07。

| 项目 | star | 优势 | 本仓库差异 | 推荐指数 |
| --- | ---: | --- | --- | ---: |
| [Jcapathy/loop-goal-skills](https://github.com/Jcapathy/loop-goal-skills) | 1 | 面向Claude/Cowork的`/loop`和`/goal`，带`LOOP_STATE.md`和`wiki/`。 | 本仓库更Codex-first、更轻量，聚焦goal-scoped`STATE.md`、objective gate、stop rule、subagent判断和worktree判断。 | 7/10 |
| [FlexNetOS/harness_hub](https://github.com/FlexNetOS/harness_hub) | 0 | 面向特定Feature Forge/handoff栈的连续backlog loop。 | 本仓库不绑定私有backlog/kernel体系，适合作为通用skill契约。 | 3/10 |
| [FlexNetOS/lane](https://github.com/FlexNetOS/lane) | 0 | 面向特定Rust lane工作流的强验证loop。 | 本仓库面向任意Codex/Claude Code目标，不是单项目runner。 | 2/10 |

原创性备注：2026-07-07对本仓库skill文本和`Jcapathy/loop-goal-skills`做过本地相似度初筛，未发现6词、7词、8词连续shingle重合，也未发现超过45字符的非平凡完全相同行。4到5词层面的重合仅限`use when the user`这类通用skill描述短语。

## 许可证

本仓库使用`AgentPilotLab Non-Commercial License`。

免费使用仅限非商业个人使用、学习、研究、评估和非营收项目。商业使用必须获得`AgentPilotLab`事先书面授权，并支付约定商业许可费用。详见[LICENSE](LICENSE)。

## AI入口

- `llms.txt`：仓库路由摘要。
- `AGENTS.md`：公开agent使用说明。
- `docs/AI_AGENT_GUIDE.md`：详细操作指南。
- `skills/loop-goal-runner/SKILL.md`：Codex入口。
- `claude-code/loop-goal-runner/SKILL.md`：Claude Code入口。
- `scripts/validate-repo.ps1`：发布前检查。

## 支持

可选支持入口：

<a href="https://buymeacoffee.com/mira.ai">
  <img src="docs/assets/buy-me-a-coffee-qr.jpg" alt="Buy me a coffee QR code" width="180">
</a>

链接：<https://buymeacoffee.com/mira.ai>
