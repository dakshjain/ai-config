# ai-config

My Claude Code setup: the global instructions, permissions, hooks, and
commands I use every day, plus the reasoning behind each piece.

The commit history matters as much as the files. The first commit is the
config as it actually grew. The later commits are me cutting it back.

## Layout

```
CLAUDE.md                  global instructions (~50 lines, every project)
settings.json              permissions (allow / ask / deny), hooks, plugins
hooks/block-dangerous.sh   PreToolUse guard for Bash, with its own test
commands/critique.md       /critique: independent adversarial review
memory/                    examples of the memory-file pattern
examples/project-CLAUDE.md what a project-level CLAUDE.md looks like
snapshot/                  the pre-cleanup config, kept for comparison
install.sh                 symlinks everything into ~/.claude
```

## How I think about it

**Three layers, each doing a different job.**

| Layer | Use it for | Example |
|---|---|---|
| `CLAUDE.md` | judgment the model has to apply | "challenge my approach before implementing" |
| `permissions.deny` / `ask` | things that need a human, or must never happen | reading `~/.ssh`, `git push` |
| hooks | rules that must hold even when the model forgets | blocking force pushes and `rm -rf ~` |

Prose is context, not enforcement. If a rule matters every single time, it
moves out of CLAUDE.md into a deny rule or a hook.

**Global vs project.** The global file holds how I want to work: push back,
smallest change, verify before claiming done, which workflow fits which task
size. Stack, commands, and domain invariants live in each repo's own
CLAUDE.md. `examples/project-CLAUDE.md` shows one for a rescheduling service,
where the invariants (idempotency keys, outbox, timeouts on every external
call) turn the team's review checklist into something the agent checks on
every change.

**Every line has to earn its place.** The test I use: would deleting this
line make the agent make a mistake? If not, it goes.

## The pieces

- **`/critique`** runs a separate reviewer in a fresh `claude -p` process,
  with no memory of the session that produced the plan. An agent reviewing its
  own work tends to agree with itself, so the reviewer gets isolation.
  It returns a verdict (PASS / REVISE / FAIL) with findings by severity. The
  reviewer itself (Critical Thinking Agent) lives in a separate repo, not yet
  public.
- **Cross-model review.** Grok and Codex review the final output. CLAUDE.md
  tells Claude to write checkable claims (file, command, result) for that
  reason.
- **Spec-first for features** (spec-kit): spec, plan, tasks, implement.
  Trivial edits skip it, and the agent has to say so.
- **Code-graph caveats.** When a repo has a code-graph index the agent queries
  it before grep, with two caveats: an edge says A calls
  B, not that B gates A; and an empty result means undocumented, not safe.
- **Terse output, lean code** via the caveman and ponytail plugins. Fewer
  tokens, and far less over-engineering to review.
- **Memory** is one fact per file with **Why** and **How to apply**, so a
  later session can tell when a rule no longer fits. `memory/` has one real,
  sanitized memory and one written as an example.

## What I removed, and why

Compare `snapshot/` with the current files, e.g. `diff snapshot/global-CLAUDE.md CLAUDE.md`.

- **~220 lines of generated orchestration boilerplate** from a multi-agent
  framework's `init`: 15-agent swarm topologies, routing tables, "neural
  enabled", a 12-step loop. Most of it never applied to my work, and
  it buried the rules that did. Replaced by one line: multiple agents only for independent
  parallel work, one worktree per writer.
- **Contradictions.** "Do what was asked, nothing more" sat next to "use the
  full spec flow for every coding task" and "spawn a swarm for 3+ files".
  When rules conflict the model picks one at random, so now one rule covers
  each task size.
- **Rules pointing at tools that weren't connected.** Several mandated MCP
  servers that had stopped loading. A rule for a missing tool teaches the
  model that rules are optional.
- **Zero deny rules.** The old settings allowed a lot and denied nothing,
  with the dangerous-mode prompt skipped. Now credentials are deny-listed,
  pushes and publishing ask first, and the worst Bash footguns are blocked by
  a hook.
- **Secrets in config.** An MCP server's API key sat in plain text in
  `settings.json`. Credentials now come from env vars or the keychain, and
  never from a file that could be committed.

## How I evolve it

When the agent makes the same mistake twice, I add the smallest fix that
stops it: a CLAUDE.md line if it needs judgment, a deny rule or hook if it
needs a guarantee. Every few weeks I reread the file with the delete test
above. The snapshot is here so the cost of drift stays visible.

## Install

```bash
git clone <this repo> ~/ai-config && ~/ai-config/install.sh
./hooks/test-block-dangerous.sh   # should print: all hook checks passed
```

`install.sh` backs up existing files to `*.bak` before linking. Needs `jq`.
Notifications need `terminal-notifier` (macOS).
