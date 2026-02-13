#!/bin/bash
# install-extras.sh — Install opsx-ext extras (rules, codex-prompts) into a project
# Compatible with bash 3.2+ (macOS default)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXTRAS_DIR="$SCRIPT_DIR/extras"

# Defaults
PROJECT_ROOT=""
FORCE=false
UNINSTALL=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install opsx-ext extras (rules, codex-prompts) into your project.

Options:
  --project-root DIR   Target project root (default: current directory)
  --force              Overwrite existing files without backup
  --uninstall          Remove installed extras
  -h, --help           Show this help message

Installed files:
  .claude/rules/opsx-ship-gate.md        Complexity gate rule
  .codex/prompts/verify-fix-loop.md      Codex verify-fix prompt
  .codex/prompts/code-review.md          Codex code review prompt
EOF
  exit 0
}

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT="$2"
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Resolve project root
if [ -z "$PROJECT_ROOT" ]; then
  PROJECT_ROOT="$(pwd)"
fi

if [ ! -d "$PROJECT_ROOT" ]; then
  echo "Error: Project root does not exist: $PROJECT_ROOT"
  exit 1
fi

# Source → Destination mapping (indexed arrays for bash 3.2 compat)
SRC_FILES=""
SRC_FILES="$SRC_FILES extras/rules/opsx-ship-gate.md"
SRC_FILES="$SRC_FILES extras/codex-prompts/verify-fix-loop.md"
SRC_FILES="$SRC_FILES extras/codex-prompts/code-review.md"

DST_FILES=""
DST_FILES="$DST_FILES .claude/rules/opsx-ship-gate.md"
DST_FILES="$DST_FILES .codex/prompts/verify-fix-loop.md"
DST_FILES="$DST_FILES .codex/prompts/code-review.md"

# Convert to arrays
set -f
IFS='
'
i=0
for f in $SRC_FILES; do
  eval "src_$i=\"$f\""
  i=$((i + 1))
done
SRC_COUNT=$i

i=0
for f in $DST_FILES; do
  eval "dst_$i=\"$f\""
  i=$((i + 1))
done
set +f
unset IFS

# Uninstall mode
if [ "$UNINSTALL" = true ]; then
  echo "Uninstalling opsx-ext extras from $PROJECT_ROOT..."
  i=0
  while [ $i -lt $SRC_COUNT ]; do
    eval "dst=\$dst_$i"
    target="$PROJECT_ROOT/$dst"
    if [ -f "$target" ]; then
      rm "$target"
      echo "  Removed: $dst"
    else
      echo "  Not found (skip): $dst"
    fi
    i=$((i + 1))
  done
  echo "Uninstall complete."
  exit 0
fi

# Install mode
echo "Installing opsx-ext extras into $PROJECT_ROOT..."
i=0
while [ $i -lt $SRC_COUNT ]; do
  eval "src=\$src_$i"
  eval "dst=\$dst_$i"
  source_file="$EXTRAS_DIR/$(echo "$src" | sed 's|^extras/||')"
  target_file="$PROJECT_ROOT/$dst"
  target_dir="$(dirname "$target_file")"

  # Create target directory
  mkdir -p "$target_dir"

  if [ -f "$target_file" ]; then
    # Check if files are identical
    if diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
      echo "  Skip (identical): $dst"
      i=$((i + 1))
      continue
    fi

    if [ "$FORCE" = true ]; then
      cp "$source_file" "$target_file"
      echo "  Overwritten (--force): $dst"
    else
      cp "$target_file" "$target_file.bak"
      cp "$source_file" "$target_file"
      echo "  Updated (backup → ${dst}.bak): $dst"
    fi
  else
    cp "$source_file" "$target_file"
    echo "  Installed: $dst"
  fi

  i=$((i + 1))
done

echo "Install complete."
