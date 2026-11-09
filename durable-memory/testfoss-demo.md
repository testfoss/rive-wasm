# Testfoss demo provenance

- Source: upstream `rive-app/rive-wasm` tag 2.49.4, commit `ada7b9f35f951ff491f65f5ffc74a3ed3c582203`.
- Nested runtime: `wasm/submodules/rive-runtime` at `a658a56a275ba473fe52e9d97a925d2468b0c853`; this pointer is intentional and must not be floated.
- Prior evidence: the isolated source-build lab recorded successful Emscripten compilation, production packaging, and Playwright animation checks at the same source and runtime pins.
- Lab-proven build: `MAKEFLAGS=-j2 ./build_all_wasm.sh -r canvas-single` from `wasm/`, using Emscripten 4.0.23. The fork demo imports the resulting local single-file module directly instead of running Parcel, avoiding Parcel's incidental package metadata changes.
- Browser coverage: four upstream `.riv` assets, a 1000×250 Canvas2D surface, non-background pixel and color-bucket thresholds, advancing frame counters, and empty page-error, failed-request, and HTTP-error logs. Chromium is driven by `.lms` through `lmwebtest playwright`.

Commands are in `testfoss/README.md`. The browser script uses port 8104 by default; set `TESTFOSS_PORT` and, if necessary, `TESTFOSS_URL` to override it. The single-file build embeds Wasm in JavaScript, so a separate `.wasm` network request is not expected. Generated build output and browser results are local artifacts only. The additive lmwebtest scenario passed against the previously built canvas-single runtime. The heavy Emscripten/native rebuild was not repeated while adding this fork content.

## Remote verification

GitHub Actions run 42643945550 passed the clean Emscripten canvas-single build, animation and Canvas2D lmwebtest checks, and browser-evidence upload.
