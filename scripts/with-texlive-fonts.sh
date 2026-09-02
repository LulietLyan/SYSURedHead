#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
  echo "usage: with-texlive-fonts.sh <command> [arguments ...]" >&2
  exit 2
fi

if ! command -v fc-match >/dev/null 2>&1 || ! command -v kpsewhich >/dev/null 2>&1; then
  exec "$@"
fi

if fc-match --format='%{family}\n' FandolFang 2>/dev/null | grep -q 'FandolFang'; then
  exec "$@"
fi

fandol_font="$(kpsewhich FandolFang-Regular.otf 2>/dev/null || true)"
if [[ -z "$fandol_font" ]]; then
  exec "$@"
fi

font_dir="$(dirname "$fandol_font")"
config_dir="$(mktemp -d)"
trap 'rm -rf -- "$config_dir"' EXIT
mkdir -p "$config_dir/cache"

config_file="$config_dir/fonts.conf"
{
  printf '%s\n' '<?xml version="1.0"?>'
  printf '%s\n' '<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">'
  printf '%s\n' '<fontconfig>'
  printf '%s\n' '  <include ignore_missing="yes">/etc/fonts/fonts.conf</include>'
  printf '%s\n' '  <include ignore_missing="yes">/usr/local/etc/fonts/fonts.conf</include>'
  printf '  <dir>%s</dir>\n' "$font_dir"
  printf '  <cachedir>%s/cache</cachedir>\n' "$config_dir"
  printf '%s\n' '</fontconfig>'
} >"$config_file"

set +e
FONTCONFIG_FILE="$config_file" "$@"
status=$?
set -e
exit "$status"
