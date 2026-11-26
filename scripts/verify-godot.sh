#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STRICT_MODE=false

if [[ "${1:-}" == "--strict" ]]; then
  STRICT_MODE=true
fi

cd "${REPO_ROOT}"

echo "=== Mana-Syndicate Verification Harness ==="

# ------------------------------------------------------------------------------
# Gate 1: Workspace Integrity
# ------------------------------------------------------------------------------
REQUIRED_FILES=(
  "AGENTS.md"
  "GOLDEN_STANDARD.md"
  ".agents/vault/INDEX.md"
  ".agents/memory/GRAPH_SUMMARY.md"
  "docs/designs/README.md"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "${f}" ]]; then
    echo "[FAIL] Gate 1 (Workspace Integrity): Missing required file '${f}'"
    exit 1
  fi
done
echo "[PASS] Gate 1 (Workspace Integrity): All required Golden Standard files present."

# ------------------------------------------------------------------------------
# Collect GDScript files (excluding addons/)
# ------------------------------------------------------------------------------
GD_FILES=()
while IFS= read -r -d '' file; do
  GD_FILES+=("${file}")
done < <(find . \( -path "./addons" -o -path "./.agents" -o -path "./.godot" -o -path "./.git" \) -prune -o -type f -name "*.gd" -print0 2>/dev/null || true)

# ------------------------------------------------------------------------------
# Gate 2: GDScript Static Anti-Bug Guards
# ------------------------------------------------------------------------------
if [[ ${#GD_FILES[@]} -eq 0 ]]; then
  echo "[SKIP] Gate 2 (GDScript Anti-Bug Guards): No .gd files yet (pre-PRD state)."
else
  FAILED_STATIC=false
  DEPRECATED_REGEX='(^|[^A-Za-z0-9_])(yield\(|export\(|onready[[:space:]]+var|\.instance\(|move_and_slide\([^)]|emit_signal\(|connect\(")'

  for gd in "${GD_FILES[@]}"; do
    if grep -nE "${DEPRECATED_REGEX}" "${gd}" >/dev/null 2>&1; then
      echo "[FAIL] Gate 2: Godot 3 deprecated syntax detected in ${gd}:"
      grep -nE "${DEPRECATED_REGEX}" "${gd}" || true
      FAILED_STATIC=true
    fi

    LINE_COUNT=$(wc -l < "${gd}" | tr -d ' ')
    if (( LINE_COUNT > 300 )); then
      if [[ "${STRICT_MODE}" == "true" ]]; then
        echo "[FAIL] Gate 2: ${gd} has ${LINE_COUNT} lines (exceeds 300-line ceiling)."
        FAILED_STATIC=true
      else
        echo "[WARN] Gate 2: ${gd} has ${LINE_COUNT} lines (recommended ceiling: 300)."
      fi
    fi
  done

  if [[ "${FAILED_STATIC}" == "true" ]]; then
    exit 1
  fi
  echo "[PASS] Gate 2 (GDScript Anti-Bug Guards): Checked ${#GD_FILES[@]} file(s)."
fi

# ------------------------------------------------------------------------------
# Gate 3: gdtoolkit (gdformat --check & gdlint)
# ------------------------------------------------------------------------------
if [[ ${#GD_FILES[@]} -eq 0 ]]; then
  echo "[SKIP] Gate 3 (gdtoolkit): No .gd files to lint/format."
elif command -v gdformat >/dev/null 2>&1 && command -v gdlint >/dev/null 2>&1; then
  gdformat --check "${GD_FILES[@]}"
  gdlint "${GD_FILES[@]}"
  echo "[PASS] Gate 3 (gdtoolkit): gdformat & gdlint passed."
else
  echo "[SKIP] Gate 3 (gdtoolkit): gdformat/gdlint not installed (install via: uv tool install gdtoolkit)."
fi

# ------------------------------------------------------------------------------
# Gate 4: Godot Headless Import & Compile Check
# ------------------------------------------------------------------------------
COMPILE_CHECK="${REPO_ROOT}/.agents/skills/godot-gdscript/assets/check_scripts_compile.gd"

if [[ ! -f "project.godot" ]]; then
  echo "[SKIP] Gate 4 (Godot Headless Compile): No project.godot yet (pre-PRD state)."
elif command -v godot >/dev/null 2>&1; then
  godot --headless --path . --import
  if [[ -f "${COMPILE_CHECK}" ]]; then
    godot --headless --path . --script "${COMPILE_CHECK}"
  else
    TMP_LOG="$(mktemp)"
    godot --headless --path . --quit > "${TMP_LOG}" 2>&1 || true
    if grep -nE "SCRIPT ERROR|^ERROR:" "${TMP_LOG}" >/dev/null 2>&1; then
      cat "${TMP_LOG}"
      rm -f "${TMP_LOG}"
      echo "[FAIL] Gate 4 (Godot Headless Compile): Errors detected."
      exit 1
    fi
    rm -f "${TMP_LOG}"
  fi
  echo "[PASS] Gate 4 (Godot Headless Compile): Project imported and scripts compiled cleanly."
else
  echo "[SKIP] Gate 4 (Godot Headless Compile): 'godot' CLI not found in PATH (install via: brew install --cask godot)."
fi

# ------------------------------------------------------------------------------
# Gate 5: Headless GUT / SceneTree Runner Tests
# ------------------------------------------------------------------------------
if [[ -f "addons/gut/gut_cmdl.gd" && -d "tests" ]]; then
  if command -v godot >/dev/null 2>&1; then
    godot --headless --path . -s addons/gut/gut_cmdl.gd -gdir=res://tests -gexit
    echo "[PASS] Gate 5 (Headless GUT): All tests passed."
  else
    echo "[SKIP] Gate 5 (Headless GUT): 'godot' CLI not found in PATH."
  fi
elif [[ -f "tests/test_runner.gd" ]]; then
  if command -v godot >/dev/null 2>&1; then
    godot --headless --path . --script res://tests/test_runner.gd
    echo "[PASS] Gate 5 (Headless SceneTree Runner): All tests passed."
  else
    echo "[SKIP] Gate 5 (Headless SceneTree Runner): 'godot' CLI not found in PATH."
  fi
else
  echo "[SKIP] Gate 5 (Headless Tests): addons/gut/gut_cmdl.gd, tests/, or tests/test_runner.gd not present yet."
fi

echo "=== Verification Complete ==="
