#!/usr/bin/env bash
# Symlink this config into ~/.claude. Existing files are moved to *.bak first.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"; dst="$HOME/.claude"
mkdir -p "$dst/hooks" "$dst/commands"
for f in CLAUDE.md settings.json hooks/block-dangerous.sh commands/critique.md; do
  if [[ -e "$dst/$f" && ! -L "$dst/$f" ]]; then mv "$dst/$f" "$dst/$f.bak"; fi
  ln -sfn "$src/$f" "$dst/$f"; echo "linked $f"
done
