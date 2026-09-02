#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  install-skill.sh [--skills-dir <directory>]

Install the redhead-document skill for the current user. By default, the
skill is copied to $HOME/.agents/skills/redhead-document. Existing content is
never overwritten.
USAGE
}

fail() {
  printf 'install-skill.sh: %s\n' "$*" >&2
  exit 1
}

skills_dir=''

while (($# > 0)); do
  case "$1" in
    --skills-dir)
      (($# >= 2)) || fail '--skills-dir requires a value'
      [[ -z "$skills_dir" ]] || fail '--skills-dir may be specified only once'
      skills_dir=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

if [[ -z "$skills_dir" ]]; then
  [[ -n "${HOME:-}" ]] || fail 'HOME is not set; pass --skills-dir explicitly'
  skills_dir="$HOME/.agents/skills"
fi

[[ "$skills_dir" != '/' ]] || fail 'refusing to use the filesystem root as a skills directory'

script_dir=$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skill_source="$script_dir/../plugins/sysu-redhead/skills/redhead-document"
destination="$skills_dir/redhead-document"

[[ -f "$skill_source/SKILL.md" ]] || fail "skill source is incomplete: $skill_source"
if [[ -e "$destination" || -L "$destination" ]]; then
  fail "destination already exists; refusing to overwrite: $destination"
fi

mkdir -p -- "$skills_dir"
mkdir -- "$destination" || fail "could not create destination: $destination"
if ! cp -R -- "$skill_source/." "$destination/"; then
  fail "copy failed; remove the incomplete destination before retrying: $destination"
fi

printf 'Installed redhead-document skill: %s\n' "$destination"
printf 'Invoke it in Codex with: $redhead-document\n'
printf 'If it is not detected immediately, restart Codex.\n'
