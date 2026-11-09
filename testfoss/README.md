# Testfoss Rive demo

This additive demo builds upstream's `canvas-single` flavor with Emscripten 4.0.23 and renders four local animations on one 1000×250 Canvas2D surface. The nested `rive-runtime` submodule remains pinned to `a658a56a275ba473fe52e9d97a925d2468b0c853`. No remote assets or cross-repo browser scripts are used.

Prerequisites are Bash, Git, Python 3, Node.js 24, and the native build tools required by upstream Rive. Then run:

```sh
npm install -g @lmctl-ai/lmctl@0.2.469
npm ci --prefix testfoss
testfoss/node_modules/.bin/playwright install chromium
./testfoss/build.sh
./testfoss/browser.sh
```

The build initializes the nested submodule over HTTPS and uses `MAKEFLAGS=-j2` by default. The browser check starts a loopback-only static server, drives Chromium through `lmwebtest playwright`, verifies advancing animation frames, canvas dimensions, occupied pixels, color variation, and clean browser/network logs, and writes a screenshot plus JSON result under `testfoss/results/`.

The workflow at `.github/workflows/testfoss.yml` runs the same build and browser check. Generated runtimes, demo bundles, dependencies, and results are intentionally not committed.
