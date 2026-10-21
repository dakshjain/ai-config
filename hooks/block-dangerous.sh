#!/usr/bin/env bash
# PreToolUse hook for Bash. Exit 2 blocks the call; stderr goes back to Claude.
# ponytail: regex list, not a shell parser. Catches the common footguns; the
# permission deny list and sandboxing are the real boundary.
cmd=$(jq -r '.tool_input.command // empty')

block() { echo "Blocked by block-dangerous.sh: $1. Ask the user to run it." >&2; exit 2; }

[[ $cmd =~ rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*[[:space:]]+(/|~|\$HOME)([[:space:]]|/?$) ]] && block "rm -rf on / or home"
[[ $cmd =~ git[[:space:]]+push.*(--force|-f([[:space:]]|$)) && ! $cmd =~ --force-with-lease ]] && block "force push"
[[ $cmd =~ git[[:space:]]+push[[:space:]]+[^[:space:]]+[[:space:]]+(main|master)([[:space:]]|$) ]] && block "direct push to main/master"
[[ $cmd =~ (curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z)?sh ]] && block "piping a download into a shell"
[[ $cmd =~ (cat|less|head|tail|bat)[[:space:]].*\.env([[:space:]]|$|\.) ]] && block "reading a .env file"
exit 0
