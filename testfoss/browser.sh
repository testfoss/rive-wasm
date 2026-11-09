#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT/testfoss/node_modules/.bin:$PATH"
PORT="${TESTFOSS_PORT:-8104}"
export TESTFOSS_URL="${TESTFOSS_URL:-http://127.0.0.1:$PORT/testfoss/demo/}"
for tool in curl lmscript lmwebtest python3; do
  command -v "$tool" >/dev/null || { echo "Missing $tool; see testfoss/README.md" >&2; exit 1; }
done

cd "$ROOT"
mkdir -p testfoss/results
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$ROOT" >testfoss/results/server.log 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true; wait "$SERVER_PID" 2>/dev/null || true' EXIT
for _ in {1..50}; do
  if curl -fsS "$TESTFOSS_URL" >/dev/null; then break; fi
  sleep 0.2
done
curl -fsS "$TESTFOSS_URL" >/dev/null
lmscript testfoss/browser.lms
