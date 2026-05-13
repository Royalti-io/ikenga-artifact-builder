#!/usr/bin/env bash
#
# ikenga-artifact-builder — install script
#
# Installs the skill into ~/.claude/skills/ikenga-artifact-builder as a
# symlink against a cached clone in ~/.cache/ikenga-skills/. Update path
# is `git -C ~/.cache/ikenga-skills/ikenga-artifact-builder pull`.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/royalti-io/ikenga-artifact-builder/main/install.sh | bash
#
# Env overrides:
#   SKILLS_DIR    target skills dir (default: $HOME/.claude/skills)
#   CACHE_DIR     clone cache dir   (default: $HOME/.cache/ikenga-skills)
#   REPO_URL      repo to clone     (default: https://github.com/royalti-io/ikenga-artifact-builder.git)
#   REF           git ref to check out (default: main)

set -euo pipefail

SKILL_NAME="ikenga-artifact-builder"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
CACHE_DIR="${CACHE_DIR:-$HOME/.cache/ikenga-skills}"
REPO_URL="${REPO_URL:-https://github.com/royalti-io/ikenga-artifact-builder.git}"
REF="${REF:-main}"

CLONE_DIR="$CACHE_DIR/$SKILL_NAME"
TARGET="$SKILLS_DIR/$SKILL_NAME"
SOURCE="$CLONE_DIR/skills/$SKILL_NAME"

log()  { printf '\033[36m[ikenga]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[ikenga]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31m[ikenga]\033[0m %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required but not installed."

mkdir -p "$SKILLS_DIR" "$CACHE_DIR"

if [ -d "$CLONE_DIR/.git" ]; then
  log "Updating cached clone at $CLONE_DIR"
  git -C "$CLONE_DIR" fetch --quiet origin "$REF"
  git -C "$CLONE_DIR" checkout --quiet "$REF"
  git -C "$CLONE_DIR" reset --quiet --hard "origin/$REF"
else
  log "Cloning $REPO_URL into $CLONE_DIR"
  git clone --quiet --branch "$REF" --depth 1 "$REPO_URL" "$CLONE_DIR"
fi

[ -d "$SOURCE" ] || die "Skill source not found at $SOURCE (repo layout changed?)."

if [ -L "$TARGET" ]; then
  log "Replacing existing symlink at $TARGET"
  rm "$TARGET"
elif [ -e "$TARGET" ]; then
  BACKUP="$TARGET.bak.$(date +%s)"
  warn "Existing non-symlink at $TARGET — backing up to $BACKUP"
  mv "$TARGET" "$BACKUP"
fi

ln -s "$SOURCE" "$TARGET"

log "Installed: $TARGET -> $SOURCE"
log "Update later: git -C $CLONE_DIR pull"
