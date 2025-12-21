# Copilot / AI Agent Instructions for LSCamoflash

Short, actionable notes to help an AI coding agent be productive in this repository.

## Big picture
- This repo packages firmware, sdcard content, patches, and supporting tools under `SOURCE`.
- Runtime artifact: a prepared SD card image assembled from `SOURCE/src/sdcard/mmcblk0p1` and `SOURCE/src/sdcard/mmcblk0p2/HACK` (overlay). See [SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh](SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh) for the SD-card init entrypoint.
- Major components:
  - Build & packaging: [SOURCE/Makefile](SOURCE/Makefile) and helper scripts in [SOURCE/src/bin](SOURCE/src/bin).
  - SD card contents: [SOURCE/src/sdcard](SOURCE/src/sdcard) and overlay `HACK/` for custom files that become the SD image root.
  - Embedded extras / contributors: `SOURCE/src/contrib/*` (e.g., `motor`, `mqtt_mitm_auth`).
  - Language modules and tests: `SOURCE/src/modules/` (notably `python/flask/` with `tox.ini` and tests).

## How this repo is built and iterated (developer workflows)
- Primary build: run `make` in `SOURCE` (use `make -C SOURCE` from repo root). That drives versioning and assembly steps.
- Version updates: `SOURCE/version.txt` and `SOURCE/src/bin/update-version.sh` are the canonical places to bump or read version info.
- SD card workflow: modify files under `SOURCE/src/sdcard/mmcblk0p2/HACK/` (this overlay is copied into the second partition). The runtime init is at [SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh](SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh).
- Installing to a target SD card: see `SOURCE/sdcard/install.sh` and `SOURCE/sdcard/install.ps1` for platform-specific steps.
- Patches: third-party patches and platform tweaks live under `SOURCE/patches/` — use these when reproducing build environments.

## Tests and local iteration
- Python module tests: go to [SOURCE/src/modules/python/flask](SOURCE/src/modules/python/flask) and run `tox` or `pytest` as appropriate (there is a `tox.ini` and `tests/` directory).
- For small changes in SD overlay, iterate by editing `HACK/` files and re-running the sdcard assembly (via `make` or the sdcard scripts).

## Project-specific conventions and patterns
- `HACK/` directories are overlays (not build sources) — they represent the final filesystem tree for the SD card partition.
- Keep runtime scripts under `HACK/sbin` and configuration under `HACK/etc`. `init.sh` is the early init.
- Hardware or protocol contributions appear under `SOURCE/src/contrib/` — treat these as small, self-contained C projects with their own `Makefile`.
- Patches under `SOURCE/patches/*` are applied to upstream sources — do not remove or rename these; they document compatibility fixes.

## Integration points and external dependencies
- MQTT and related work: see `SOURCE/src/contrib/mqtt_mitm_auth/` and `SOURCE/patches/mosquitto-2.0.20/` for how MQTT components are integrated.
- Native binaries and build scripts: `SOURCE/src/bin` contains helper scripts used by top-level `Makefile` (e.g., `update-version.sh`).

## Quick examples for agents
- To run tests for the Flask module:

  cd SOURCE/src/modules/python/flask
  tox  # or `pytest -q` for a quicker run

- To assemble or rebuild deliverables:

  make -C SOURCE

- To modify sdcard init behavior, edit and inspect:

  [SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh](SOURCE/src/sdcard/mmcblk0p2/HACK/sbin/init.sh)

## When editing, prefer minimal, local changes
- Preserve the overlay layout and package-level `Makefile` rules; small hacks belong in `HACK/` or `contrib/` rather than changing upstream structure.

If any part of the build or runtime flow above is unclear or you want deeper examples (for example, the exact `make` targets used in CI or how patches are applied), tell me which area and I'll expand the doc with concrete commands and file references.
