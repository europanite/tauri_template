# Release Packaging Pipeline

このテンプレートでは、Windows向けTauriアプリを販売用ZIPまで作成するための
ローカルリリースパイプラインを用意している。

## 1. アプリ情報を設定する

```bash
bash scripts/set-app-meta.sh \
  "My App" \
  "com.example.my-app" \
  "1.0.0"
```

Tauri の `version` は semver が必要なので、`1.0` ではなく `1.0.0` を使う。

## 2. 販売用ドキュメントを用意する

以下の3ファイルをアプリごとに書き換える。

```text
docs/release/README.txt
docs/release/LICENSE.txt
docs/release/THIRD_PARTY_NOTICES.txt
```

この3ファイルは販売用ZIPにそのままコピーされる。スクリプト側では生成しない。

## 3. Windows販売用ZIPを作る

```powershell
node scripts\build-windows-release-package.cjs
```

生成物の例:

```text
release-booth\my-app-win_1.0.zip
release-booth\my-app-win_1.0.zip.sha256.txt
```

ZIPの中身は以下のみ。

```text
my-app-win_1.0-setup.exe
my-app-win_1.0.msi
README.txt
LICENSE.txt
THIRD_PARTY_NOTICES.txt
```

## 4. ビルド済みインストーラーでZIPだけ作り直す

```powershell
node scripts\build-windows-release-package.cjs --skip-build
```

## 5. 個人名やメールも検査する

```powershell
$env:EXTRA_PRIVACY_MARKERS = "Your Name;your-email@example.com"
node scripts\build-windows-release-package.cjs
```

## 方針

- `target/`, `dist/`, `node_modules/`, ソースコード、ログはZIPに入れない
- `README.txt`, `LICENSE.txt`, `THIRD_PARTY_NOTICES.txt` は `docs/release/` からbyte-for-byteでコピーする
- SHA256はZIPの外に出す
- WindowsではSUBSTドライブからビルドし、`C:\Users\...` の混入を避ける
