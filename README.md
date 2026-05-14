# [Tauri Template](https://github.com/europanite/tauri_template "Tauri Template")

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![OS](https://img.shields.io/badge/OS-Linux%20%7C%20macOS%20%7C%20Windows-blue)

!["image"](./assets/images/image.png)

A minimal template for building, validating, and releasing paid desktop applications continuously.

This template uses **Tauri v2 + Vite + React + TypeScript**. It is not tied to Expo or a fixed `frontend/app` directory. For each new app, the intended workflow is to replace only the React screens in `src/` and the native commands in `src-tauri/src/`.

## Goals

- Release quickly with one repository per app.
- Build Windows, macOS, and Linux artifacts with GitHub Actions.
- Verify release builds locally before publishing.
- Reduce missing items in README files, sales pages, and release notes.
- Avoid Node 20 GitHub Actions warnings by opting into Node 24 action execution.
```

## Initial setup

```bash
npm install
npm run tauri dev
```

## Local validation

```bash
npm run check
npm run build
npm run tauri build
```

Or run the bundled release check script:

```bash
bash scripts/release-check.sh
```

## Create a new app from this template

```bash
bash scripts/set-app-meta.sh \
  "Anime Tag Vault" \
  "com.example.anime-tag-vault" \
  "0.1.0"
```

Arguments:

1. `productName`
2. `identifier`
3. `version`

Then edit these files:

- `docs/APP_SPEC.md`
- `src/App.tsx`
- `src-tauri/src/lib.rs`
- `README.md`

## CI

The standard validation workflow runs on `push` and `pull_request`.

```bash
npm run check
cargo test --manifest-path src-tauri/Cargo.toml
```

## Release

Push a tag such as `v0.1.0` to create a GitHub Release draft and upload artifacts for each OS.

```bash
git tag v0.1.0
git push origin v0.1.0
```

You can also run the release workflow manually:

1. Open GitHub Actions.
2. Select the `release` workflow.
3. Click `Run workflow`.

## GitHub Secrets

The minimal setup can create draft releases with only `GITHUB_TOKEN`.

If you use automatic updates or code signing, configure the additional secrets below.

| Secret | Purpose |
|---|---|
| `TAURI_SIGNING_PRIVATE_KEY` | Private key for the Tauri updater |
| `TAURI_SIGNING_PRIVATE_KEY_PASSWORD` | Password for the private key |
| `APPLE_CERTIFICATE` | Certificate for macOS code signing |
| `APPLE_CERTIFICATE_PASSWORD` | Password for the macOS certificate |
| `APPLE_SIGNING_IDENTITY` | macOS signing identity |
| `APPLE_ID` | Apple ID for notarization |
| `APPLE_PASSWORD` | App-specific password |
| `APPLE_TEAM_ID` | Apple Team ID |
| `WINDOWS_CERTIFICATE` | Certificate for Windows code signing |
| `WINDOWS_CERTIFICATE_PASSWORD` | Password for the Windows certificate |

## Design policy

- Let `tauri-action` build the release artifacts first.
- Do not hard-code a frontend directory path in workflows.
- Keep `beforeBuildCommand` as `npm run build`.
- Keep app-specific logic inside Rust commands and React components.
- Use a consistent release asset naming pattern.
- Verify releases with a GitHub Release draft before uploading to a store or sales platform.

## Important notes

Official macOS and Windows sales usually require code signing and notarization. If you first validate demand by selling a zip file or installer through platforms such as BOOTH, unsigned apps may still show security warnings. Use `docs/SALES_CHECKLIST.md` before publishing.
