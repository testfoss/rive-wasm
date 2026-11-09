# Testfoss fork guidance

Keep upstream source, examples, lockfiles, and existing workflows unchanged. Fork additions belong in `testfoss/`, `durable-memory/`, and `.github/workflows/testfoss.yml`; the root README may contain only the short Testfoss section.

The demo uses `wasm/build_all_wasm.sh -r canvas-single` with `RIVE_WASM_EMSDK_VERSION=4.0.23`. Preserve the nested `wasm/submodules/rive-runtime` pin `a658a56a275ba473fe52e9d97a925d2468b0c853`; do not replace it with a branch or another runtime revision.

Run `./testfoss/build.sh` and `./testfoss/browser.sh` after changing the demo. Browser checks must remain self-contained and invoke `lmwebtest playwright` from `browser.lms`. Do not commit generated Wasm, JavaScript bundles, `node_modules`, build trees, screenshots, or results. See `durable-memory/testfoss-demo.md` for provenance and limitations.
