#!/usr/bin/env bash
# devflow lint hook
# Runs the appropriate linter after a file is written or edited.
# Receives tool data on stdin as JSON (PostToolUse hook format).

set -euo pipefail

# Support both direct invocation and hook mode (stdin JSON)
FILE_PATH="${1:-}"

if [ -z "$FILE_PATH" ]; then
  INPUT=$(cat)
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
fi

# Skip if no path resolved or file doesn't exist
if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

run_if_available() {
  local tool="$1"
  shift
  if command -v "$tool" &>/dev/null; then
    echo "[devflow/lint] Running $tool on $FILE_PATH"
    "$tool" "$@" || true  # report but don't block
  fi
}

case "$EXT" in
  py)
    if command -v ruff &>/dev/null; then
      echo "[devflow/lint] Running ruff on $FILE_PATH"
      ruff check "$FILE_PATH" || true
    elif command -v flake8 &>/dev/null; then
      echo "[devflow/lint] Running flake8 on $FILE_PATH"
      flake8 "$FILE_PATH" || true
    fi
    ;;

  js|jsx|mjs|cjs)
    run_if_available eslint "$FILE_PATH"
    ;;

  ts|tsx)
    run_if_available eslint "$FILE_PATH"
    ;;

  go)
    if command -v golangci-lint &>/dev/null; then
      echo "[devflow/lint] Running golangci-lint on $(dirname "$FILE_PATH")/..."
      golangci-lint run "$(dirname "$FILE_PATH")/..." || true
    elif command -v go &>/dev/null; then
      echo "[devflow/lint] Running go vet on $(dirname "$FILE_PATH")/..."
      go vet "$(dirname "$FILE_PATH")/..." || true
    fi
    ;;

  rs)
    if command -v cargo &>/dev/null; then
      # Find the nearest Cargo.toml
      PROJECT_DIR=$(dirname "$FILE_PATH")
      while [ "$PROJECT_DIR" != "/" ]; do
        if [ -f "$PROJECT_DIR/Cargo.toml" ]; then
          echo "[devflow/lint] Running cargo clippy in $PROJECT_DIR"
          (cd "$PROJECT_DIR" && cargo clippy --quiet 2>&1) || true
          break
        fi
        PROJECT_DIR=$(dirname "$PROJECT_DIR")
      done
    fi
    ;;

  sh|bash)
    run_if_available shellcheck "$FILE_PATH"
    ;;

  rb)
    run_if_available rubocop "$FILE_PATH"
    ;;

  # Silently skip file types with no known linter
esac

exit 0
