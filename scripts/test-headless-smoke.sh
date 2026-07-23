#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
godot_bin="${GODOT_BIN:-godot}"
smoke_root="$(mktemp -d)"
trap 'rm -rf "$smoke_root"' EXIT

mkdir -p "$smoke_root/data" "$smoke_root/config" "$smoke_root/cache"

run_godot() {
	XDG_DATA_HOME="$smoke_root/data" \
	XDG_CONFIG_HOME="$smoke_root/config" \
	XDG_CACHE_HOME="$smoke_root/cache" \
	"$godot_bin" "$@" 2>&1
}

import_log="$smoke_root/import.log"
smoke_log="$smoke_root/smoke.log"

run_godot --headless --path "$project_dir" --editor --import --quit | tee "$import_log"
run_godot --headless --path "$project_dir" --script res://tests/automate_smoke.gd | tee "$smoke_log"

if rg -q 'SCRIPT ERROR:|Parse Error:|Failed to load script' "$import_log" "$smoke_log" || \
	! rg -q 'Automate smoke test passed' "$smoke_log"; then
	echo "Headless smoke test found errors." >&2
	exit 1
fi

echo "Headless smoke test passed."
