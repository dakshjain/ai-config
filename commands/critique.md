---
description: Adversarially critique a plan, proposal, design, or the current diff with the Critical Thinking Agent
argument-hint: [file.md] | --diff | --staged | <free text>
allowed-tools: Bash(~/critical-thinking-agent/bin/cta:*), Bash(git diff:*), Bash(git status:*), Read, Write
---

Run the Critical Thinking Agent (CTA) against the target below. CTA is an
independent evaluator: a separate `claude -p` process with no memory of this
session, so its criticism is not shaped by whatever we just built together.

Target: $ARGUMENTS

## 1. Pick the mode

- Argument is a file path → `evaluate --proposal <path>`
- Argument is `--diff`, `--staged`, empty, or names a git ref → `review-code`
  (add `--staged` or `--base <ref>` as appropriate)
- Argument is free text, or the thing to critique is a plan from this
  conversation → write it verbatim to a scratch file first, then
  `evaluate --proposal <that file>`. Write down the plan as it stands; do not
  improve it on the way.

## 2. Run it

```
~/critical-thinking-agent/bin/cta <mode> <args> \
  --task "<what this is trying to achieve>" \
  --output /tmp/cta-review.json
```

Takes a few minutes: seven stages, each its own subprocess. No API key needed —
it uses this machine's Claude Code auth. Add `--model haiku` for a cheap pass,
`--verbose` to watch the stages.

Exit codes: 0 PASS or PASS_WITH_CONCERNS, 2 REVISE, 3 FAIL,
4 INSUFFICIENT_EVIDENCE, 1 tooling error. Non-zero is the expected result of a
useful critique, not a failure of the command.

## 3. Report back

Read the JSON report and present:

- the verdict, its confidence, and the one-line reason
- every CRITICAL and HIGH finding, with its recommendation
- MEDIUM and below, one line each
- what the report lists as missing information and required actions
- the alternatives it generated, if any beat the current approach

Then stop. Do not start fixing anything unless I ask. If a finding is wrong,
say so and why — the CTA is a reviewer, not an authority, and it does not see
the code unless it was handed the files.
