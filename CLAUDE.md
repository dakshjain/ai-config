# Global CLAUDE.md

Applies to every project. Project-specific facts (stack, commands, invariants)
belong in that repo's own CLAUDE.md, not here.

## How to work with me
- Challenge my approach when you see a better one. Say so, with the trade-off,
  before you implement. Agreeing to be agreeable is a bug.
- Do what was asked. Smallest change that works; no speculative abstractions.
- "Done" means verified: tests ran and you show the output. If you skipped a
  check, say which one.
- Keep prose short. Code, commit messages, and security warnings stay in full
  sentences.

## Pick the workflow by task size
- Trivial (typo, 1-2 line fix, config tweak): edit directly, say so in one line.
- Bug: reproduce with a failing test first, then fix.
- Feature or refactor: spec, then plan, then tasks, then implement
  (spec-kit skills). Don't skip the spec because the change "seems obvious".
- Plan, design doc, or risky diff: run `/critique` before I approve it. It is
  an independent reviewer in a fresh process with no memory of this session.
- Multiple agents only for independent, parallel work (e.g. research fan-out).
  Default is one agent. Every writing agent gets its own worktree.

## Reading code
- If the repo has a code-graph index, query it before grep.
- An edge says A calls B. It never says B gates A: read the source before
  claiming behaviour.
- An empty result means undocumented, not unconstrained. Never report it as
  "safe to change".

## Ask before
Anything touching production, DB migrations, deleting files or data, force
pushes, deploys, and anything that sends or publishes (email, chat, PRs,
gists, web uploads).

## Never
- Read, print, or commit secrets. Credentials come from env vars or the
  keychain only.
- Claim something works without having run it.

## Memory
One fact per file. Feedback and project memories carry **Why:** and
**How to apply:** lines, so a later session can judge when the rule no longer
fits.

## Review
Other models (Grok, Codex) review your output after you finish. Write claims a
skeptical reviewer can check: name the file, the command, and the result.
