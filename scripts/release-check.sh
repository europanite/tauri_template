#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Node"
node --version
npm --version

echo "==> Rust"
rustc --version
cargo --version

echo "==> Install JS dependencies"
npm install

echo "==> Typecheck and web build"
npm run build

echo "==> Rust tests"
cargo test --manifest-path src-tauri/Cargo.toml

echo "==> Tauri build"
npm run tauri build

echo "==> Done"
