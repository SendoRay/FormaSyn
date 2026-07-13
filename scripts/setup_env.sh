#!/usr/bin/env bash
# ============================================================================
# FormaSyn environment setup
# ----------------------------------------------------------------------------
# Installs BOTH the system tools the pipeline shells out to AND the Python
# packages it imports. Idempotent — safe to re-run. Primary path: macOS/arm64
# with Homebrew (arm64 bottles exist for all four EDA tools).
# ============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> [1/4] Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: Homebrew not found. Install it from https://brew.sh and re-run." >&2
  exit 1
fi

echo "==> [2/4] Installing system EDA tools"
# verilator: simulate | yosys: synth+area | nextpnr-ice40: place&route
# icestorm: provides icetime (post-PnR timing -> real Fmax)
HOMEBREW_NO_AUTO_UPDATE=1 brew install verilator yosys nextpnr-ice40 icestorm

echo "==> [3/4] Python venv (.venv) + packages"
if [ ! -x .venv/bin/python ]; then
  echo "  creating .venv"
  python3 -m venv .venv
fi
.venv/bin/python -m pip install --upgrade pip >/dev/null
.venv/bin/python -m pip install -r requirements.txt

echo "==> [4/4] Verifying toolchain"
status=0
for t in verilator yosys nextpnr-ice40 icetime; do
  if command -v "$t" >/dev/null 2>&1; then
    case "$t" in
      icetime|icepack) info="$(command -v "$t")" ;;  # no --version flag
      *) info="$("$t" --version 2>&1 | head -1 || true)" ;;
    esac
    printf "  OK   %-14s %s\n" "$t" "$info"
  else
    printf "  MISS %-14s (not on PATH)\n" "$t"; status=1
  fi
done
.venv/bin/python - <<'PY'
import importlib
for m in ["anthropic","openai","sympy","numpy","scipy","pandas","yaml","pydantic"]:
    try:
        importlib.import_module(m); print(f"  OK   py:{m}")
    except Exception as e:
        print(f"  MISS py:{m} ({e})")
PY

echo
echo "==> Done. Activate the environment with:  source .venv/bin/activate"
[ "$status" -eq 0 ] || { echo "WARNING: some system tools are missing (see MISS above)." >&2; exit "$status"; }
