#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME="wasm/submodules/rive-runtime"
EXPECTED_RUNTIME="a658a56a275ba473fe52e9d97a925d2468b0c853"
RECORDED_RUNTIME="$(git -C "$ROOT" ls-tree HEAD "$RUNTIME" | cut -d' ' -f3 | cut -f1)"
if [[ "$RECORDED_RUNTIME" != "$EXPECTED_RUNTIME" ]]; then
  echo "Unexpected nested rive-runtime pin: $RECORDED_RUNTIME" >&2
  exit 1
fi

git -C "$ROOT" -c url.https://github.com/.insteadOf=git@github.com: \
  submodule update --init --recursive "$RUNTIME"
ACTUAL_RUNTIME="$(git -C "$ROOT/$RUNTIME" rev-parse HEAD)"
if [[ "$ACTUAL_RUNTIME" != "$EXPECTED_RUNTIME" ]]; then
  echo "Nested rive-runtime checkout does not match $EXPECTED_RUNTIME" >&2
  exit 1
fi

cd "$ROOT/wasm"
export RIVE_WASM_EMSDK_VERSION=4.0.23
export MAKEFLAGS="${MAKEFLAGS:--j2}"
./build_all_wasm.sh -r canvas-single
test -s "$ROOT/js/npm/canvas_advanced_single/canvas_advanced_single.mjs"
