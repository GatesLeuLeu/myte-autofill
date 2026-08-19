#!/usr/bin/env bash

set -euo pipefail

root_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist_path=""
write_github_output=false

usage() {
  printf 'Usage: %s [--root-path PATH] [--dist-path PATH] [--write-github-output]\n' "${0##*/}" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root-path)
      [[ $# -ge 2 ]] || { usage; exit 1; }
      root_path="$2"
      shift 2
      ;;
    --dist-path)
      [[ $# -ge 2 ]] || { usage; exit 1; }
      dist_path="$2"
      shift 2
      ;;
    --write-github-output)
      write_github_output=true
      shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

root_path="$(cd "$root_path" && pwd)"
dist_path="${dist_path:-"$root_path/dist"}"
manifest_path="$root_path/manifest.json"
firefox_manifest_path="$root_path/firefox/manifest.json"

for path in "$manifest_path" "$firefox_manifest_path"; do
  [[ -f "$path" ]] || { printf 'Required manifest not found: %s\n' "$path" >&2; exit 1; }
done

read_manifest_version() {
  node --input-type=module -e 'const fs = await import("node:fs"); const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); if (!manifest.version) process.exit(1); process.stdout.write(manifest.version);' "$1"
}

version="$(read_manifest_version "$manifest_path")" || { printf 'manifest.json is missing a version value.\n' >&2; exit 1; }
firefox_version="$(read_manifest_version "$firefox_manifest_path")" || { printf 'Firefox manifest is missing a version value.\n' >&2; exit 1; }
[[ "$version" == "$firefox_version" ]] || { printf 'Firefox manifest version must match the authoritative root manifest.json version.\n' >&2; exit 1; }

stage_dir="$dist_path/firefox-package-$version"
zip_name="myte-autofill-$version-firefox.zip"
zip_path="$dist_path/$zip_name"
contents_path="$dist_path/myte-autofill-$version-firefox-contents.txt"
product_paths=(background.js content.js panel.html styles.css icons)

mkdir -p "$dist_path"
rm -rf "$stage_dir"
rm -f "$zip_path"
mkdir -p "$stage_dir"
cp "$firefox_manifest_path" "$stage_dir/manifest.json"

for relative_path in "${product_paths[@]}"; do
  source_path="$root_path/$relative_path"
  [[ -e "$source_path" ]] || { printf 'Required packaging path not found: %s\n' "$relative_path" >&2; exit 1; }
  cp -R "$source_path" "$stage_dir/$relative_path"
done

(cd "$stage_dir" && LC_ALL=C find . -type f -printf '%P\n' | LC_ALL=C sort > "$contents_path")
(cd "$stage_dir" && zip -q -D -r "$zip_path" .)
[[ -f "$zip_path" ]] || { printf 'Package creation failed: %s\n' "$zip_path" >&2; exit 1; }

printf 'Created Firefox package: %s\nVersion: %s\n' "$zip_path" "$version"

if [[ "$write_github_output" == true && -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    printf 'package_path=%s\n' "$zip_path"
    printf 'package_name=%s\n' "$zip_name"
    printf 'package_version=%s\n' "$version"
    printf 'contents_path=%s\n' "$contents_path"
  } >> "$GITHUB_OUTPUT"
fi
