#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  init-document.sh --type <notice|request|joint|letter|order|minutes|campus> --output <directory>

Create a self-contained SYSURedHead draft project in a new or empty directory.
Existing destination content is never overwritten.
USAGE
}

fail() {
  printf 'init-document.sh: %s\n' "$*" >&2
  exit 1
}

document_type=''
output_dir=''

while (($# > 0)); do
  case "$1" in
    --type)
      (($# >= 2)) || fail '--type requires a value'
      [[ -z "$document_type" ]] || fail '--type may be specified only once'
      document_type=$2
      shift 2
      ;;
    --output)
      (($# >= 2)) || fail '--output requires a value'
      [[ -z "$output_dir" ]] || fail '--output may be specified only once'
      output_dir=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      (($# == 0)) || fail "unexpected positional argument: $1"
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ -n "$document_type" ]] || fail 'missing required --type option'
[[ -n "$output_dir" ]] || fail 'missing required --output option'

case "$document_type" in
  notice) template_file='notice.tex' ;;
  request) template_file='request.tex' ;;
  joint) template_file='joint-notice.tex' ;;
  letter) template_file='letter.tex' ;;
  order) template_file='order.tex' ;;
  minutes) template_file='minutes.tex' ;;
  campus) template_file='campus-report.tex' ;;
  *)
    fail "unsupported type '$document_type'; expected notice, request, joint, letter, order, minutes, or campus"
    ;;
esac

script_dir=$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
template_root="$script_dir/../assets/template"
required_files=(
  'sysuredhead.cls'
  'sysuredhead-fonts.sty'
  'sysuredhead-layout.sty'
  'sysuredhead-components.sty'
  'latexmkrc'
  'Makefile'
  "types/$template_file"
)

missing_files=()
for relative_path in "${required_files[@]}"; do
  if [[ ! -f "$template_root/$relative_path" ]]; then
    missing_files+=("$relative_path")
  fi
done

if ((${#missing_files[@]} > 0)); then
  printf 'init-document.sh: bundled template is incomplete:\n' >&2
  printf '  - %s\n' "${missing_files[@]}" >&2
  exit 1
fi

if [[ -L "$output_dir" ]]; then
  fail "output must not be a symbolic link: $output_dir"
fi

if [[ -e "$output_dir" && ! -d "$output_dir" ]]; then
  fail "output exists and is not a directory: $output_dir"
fi

if [[ -d "$output_dir" ]] && [[ -n "$(find "$output_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
  fail "output directory is not empty; refusing to overwrite: $output_dir"
fi

mkdir -p -- "$output_dir"

copy_exclusive() {
  local source_path=$1
  local destination_path=$2

  if ! (umask 022; set -o noclobber; command cat "$source_path" >"$destination_path"); then
    fail "destination appeared while initializing; refusing to overwrite: $destination_path"
  fi
}

for relative_path in "${required_files[@]:0:6}"; do
  copy_exclusive "$template_root/$relative_path" "$output_dir/$relative_path"
done
copy_exclusive "$template_root/types/$template_file" "$output_dir/document.tex"

printf 'Created SYSURedHead %s draft project: %s\n' "$document_type" "$output_dir"
printf 'Next: make -C %q\n' "$output_dir"
printf 'The result is a typesetting draft and has no formal-document effect.\n'
