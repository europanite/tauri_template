# Release Runbook

## 1. Before coding

1. Fill `docs/APP_SPEC.md`.
2. Decide `productName`, `identifier`, and `version`.
3. Run `scripts/set-app-meta.sh`.
4. Commit the initialized app.

## 2. Local development

```bash
npm install
npm run tauri dev
```

## 3. Local release check

```bash
bash scripts/release-check.sh
```

This runs:

- `npm install`
- `npm run build`
- `cargo test`
- `npm run tauri build`

## 4. Version bump

Edit both files:

- `package.json`
- `src-tauri/tauri.conf.json`

The version must match.

## 5. Create release draft

```bash
git add .
git commit -m "release: v0.1.0"
git tag v0.1.0
git push origin main --tags
```

The release workflow creates a draft release. Do not publish it immediately.

## 6. Smoke test artifacts

Download from the GitHub Release draft and test:

- Windows install / launch / uninstall
- macOS open behavior and security warning
- Linux AppImage launch permission
- Main paid workflow
- Error messages
- Offline behavior

## 7. Publish

After manual verification, publish the GitHub Release or upload the tested artifact to the sales platform.

## 8. Hotfix rule

For small fixes:

1. Patch only the affected file.
2. Bump patch version: `0.1.0` -> `0.1.1`.
3. Add a short release note.
4. Rebuild and smoke test.
