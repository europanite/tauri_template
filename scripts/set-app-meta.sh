#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 'Product Name' 'com.example.app-id' '0.1.0'" >&2
  exit 1
fi

PRODUCT_NAME="$1"
IDENTIFIER="$2"
VERSION="$3"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAURI_CONF="$ROOT_DIR/src-tauri/tauri.conf.json"
PACKAGE_JSON="$ROOT_DIR/package.json"
CARGO_TOML="$ROOT_DIR/src-tauri/Cargo.toml"

node - <<'NODE' "$TAURI_CONF" "$PACKAGE_JSON" "$PRODUCT_NAME" "$IDENTIFIER" "$VERSION"
const fs = require('fs');
const [tauriConfPath, packageJsonPath, productName, identifier, version] = process.argv.slice(2);

const tauriConf = JSON.parse(fs.readFileSync(tauriConfPath, 'utf8'));
tauriConf.productName = productName;
tauriConf.identifier = identifier;
tauriConf.version = version;
if (tauriConf.app?.windows?.[0]) {
  tauriConf.app.windows[0].title = productName;
}
fs.writeFileSync(tauriConfPath, `${JSON.stringify(tauriConf, null, 2)}\n`);

const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
packageJson.version = version;
fs.writeFileSync(packageJsonPath, `${JSON.stringify(packageJson, null, 2)}\n`);
NODE

python3 - <<'PY' "$CARGO_TOML" "$VERSION"
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
version = sys.argv[2]
text = path.read_text()
text = re.sub(r'^version = ".*"$', f'version = "{version}"', text, count=1, flags=re.MULTILINE)
path.write_text(text)
PY

echo "Updated app metadata:"
echo "  productName: $PRODUCT_NAME"
echo "  identifier:  $IDENTIFIER"
echo "  version:     $VERSION"
