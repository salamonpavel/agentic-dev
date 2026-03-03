#!/usr/bin/env bash
# devflow format script
# Formats a file using the appropriate formatter.
# Can be used as a PostToolUse hook or called directly: format.sh <file>

set -euo pipefail

# Support both direct invocation and hook mode (stdin JSON)
FILE_PATH="${1:-}"

if [ -z "$FILE_PATH" ]; then
  INPUT=$(cat)
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

format_if_available() {
  local tool="$1"
  shift
  if command -v "$tool" &>/dev/null; then
    echo "[devflow/format] Running $tool on $FILE_PATH"
    "$tool" "$@" || true
  fi
}

case "$EXT" in
  py)
    if command -v ruff &>/dev/null; then
      format_if_available ruff format "$FILE_PATH"
    else
      format_if_available black "$FILE_PATH"
    fi
    ;;

  js|jsx|ts|tsx|mjs|cjs|json|css|scss|html|md|yaml|yml)
    format_if_available prettier --write "$FILE_PATH"
    ;;

  go)
    format_if_available gofmt -w "$FILE_PATH"
    ;;

  rs)
    format_if_available rustfmt "$FILE_PATH"
    ;;

  sh|bash)
    format_if_available shfmt -w "$FILE_PATH"
    ;;

  rb)
    format_if_available rubocop -a "$FILE_PATH"
    ;;

  # Silently skip file types with no known formatter
esac

exit 0
