#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

command -v latexmk >/dev/null 2>&1 || {
  echo "error: latexmk is required" >&2
  exit 1
}
command -v pdfinfo >/dev/null 2>&1 || {
  echo "error: pdfinfo is required" >&2
  exit 1
}
command -v sha256sum >/dev/null 2>&1 || {
  echo "error: sha256sum is required" >&2
  exit 1
}

tmp_root="$(mktemp -d)"
trap 'rm -rf -- "$tmp_root"' EXIT

original_manifest="tests/original-template.sha256"
if ! sha256sum --check --status "$original_manifest"; then
  sha256sum --check "$original_manifest" || true
  echo "error: an original template file differs from the preserved baseline" >&2
  exit 1
fi

[[ "$(grep -Fc '\AtBeginDocument{\fontsize{16bp}{29.6bp}' sysuredhead-layout.sty)" -eq 1 ]] || {
  echo "error: the added template no longer matches the original 29.6 bp body baseline" >&2
  exit 1
}
[[ "$(grep -Fc 'beforeskip=\baselineskip-\ccwd' sysuredhead-layout.sty)" -eq 4 ]] || {
  echo "error: the four heading levels no longer match the original before-skip" >&2
  exit 1
}
[[ "$(grep -Fc 'afterskip=\baselineskip-\ccwd' sysuredhead-layout.sty)" -eq 4 ]] || {
  echo "error: the four heading levels no longer match the original after-skip" >&2
  exit 1
}

make examples

sources=(RedHead.tex examples/*.tex)
for source in "${sources[@]}"; do
  name="$(basename "${source%.tex}")"
  pdf="build/$name.pdf"
  log="build/$name.log"

  [[ -s "$pdf" ]] || {
    echo "error: missing PDF $pdf" >&2
    exit 1
  }
  [[ -s "$log" ]] || {
    echo "error: missing log $log" >&2
    exit 1
  }

  pdfinfo "$pdf" | grep -Eq '^Page size:[[:space:]]+595(\.2[0-9]*)? x 841(\.8[0-9]*)? pts \(A4\)$' || {
    echo "error: $pdf is not A4" >&2
    pdfinfo "$pdf" | grep '^Page size:' >&2 || true
    exit 1
  }

  if grep -En '(^!|LaTeX Error|Undefined control sequence|Emergency stop|Fatal error|Missing character|Overfull \\[hv]box|Package .* Error|Class .* Error)' "$log"; then
    echo "error: blocking LaTeX diagnostic in $log" >&2
    exit 1
  fi
done

forbidden_example_tokens=(
  '\makeatletter'
  '\@hangfrom'
  '\vskip -'
  '\begin{tabularx}'
)
for token in "${forbidden_example_tokens[@]}"; do
  if grep -Fn "$token" examples/*.tex; then
    echo "error: example source contains internal layout token: $token" >&2
    exit 1
  fi
done

for source in examples/*.tex; do
  grep -q '不具公文效力' "$source" || {
    echo "error: example lacks a visible non-official label: $source" >&2
    exit 1
  }
done

test_sources=(
  tests/default-options.tex
  tests/font-fallback.tex
  tests/oneside-option.tex
  tests/validation-warnings.tex
)
for source in "${test_sources[@]}"; do
  latexmk "$source" >/dev/null 2>&1
done

grep -q 'SYSUREDHEAD-TEST-DEFAULT-TWOSIDE=TRUE' build/default-options.log || {
  echo "error: sysuredhead is not two-sided by default" >&2
  exit 1
}
grep -q 'SYSUREDHEAD-TEST-ONESIDE=TRUE' build/oneside-option.log || {
  echo "error: the oneside class option did not take effect" >&2
  exit 1
}
grep -q 'Package sysuredhead-fonts Warning: Mark font' build/font-fallback.log || {
  echo "error: missing optional font did not emit a fallback warning" >&2
  exit 1
}
grep -q '签发人' build/validation-warnings.log || {
  echo "error: missing-signer validation warning was not emitted" >&2
  exit 1
}
grep -q '份号' build/validation-warnings.log || {
  echo "error: missing-copy-number validation warning was not emitted" >&2
  exit 1
}
mkdir -p "$tmp_root/invalid-layout"
if xelatex \
  -file-line-error \
  -halt-on-error \
  -interaction=nonstopmode \
  -output-directory="$tmp_root/invalid-layout" \
  tests/invalid-layout.tex >"$tmp_root/invalid-layout.stdout" 2>&1; then
  echo "error: an unknown layout value was silently accepted" >&2
  exit 1
fi
grep -q 'redhead/layout' "$tmp_root/invalid-layout.stdout" || {
  echo "error: unknown layout failure did not identify the configuration key" >&2
  exit 1
}

manifest="plugins/sysu-redhead/.codex-plugin/plugin.json"
marketplace=".agents/plugins/marketplace.json"
python3 -m json.tool "$manifest" >/dev/null
python3 -m json.tool "$marketplace" >/dev/null

skill_root="plugins/sysu-redhead/skills/redhead-document"
required_skill_files=(
  "$skill_root/SKILL.md"
  "$skill_root/agents/openai.yaml"
  "$skill_root/references/fields.md"
  "$skill_root/references/safety.md"
  "$skill_root/scripts/init-document.sh"
)
for file in "${required_skill_files[@]}"; do
  [[ -s "$file" ]] || {
    echo "error: missing skill file $file" >&2
    exit 1
  }
done

"scripts/install-skill.sh" --skills-dir "$tmp_root/user-skills" >/dev/null
installed_skill="$tmp_root/user-skills/redhead-document"
diff -qr "$skill_root" "$installed_skill" >/dev/null || {
  echo "error: the command-installed skill differs from the packaged skill" >&2
  exit 1
}
if "scripts/install-skill.sh" --skills-dir "$tmp_root/user-skills" >/dev/null 2>&1; then
  echo "error: the skill installer overwrote an existing installation" >&2
  exit 1
fi

template_root="$skill_root/assets/template"
template_files=(
  sysuredhead.cls
  sysuredhead-fonts.sty
  sysuredhead-layout.sty
  sysuredhead-components.sty
  latexmkrc
  Makefile
)
for file in "${template_files[@]}"; do
  cmp "$file" "$template_root/$file" >/dev/null || {
    echo "error: plugin template is out of sync: $file" >&2
    exit 1
  }
done

template_types=(
  notice.tex
  request.tex
  joint-notice.tex
  letter.tex
  order.tex
  minutes.tex
  campus-report.tex
)
for file in "${template_types[@]}"; do
  cmp "examples/$file" "$template_root/types/$file" >/dev/null || {
    echo "error: plugin template is out of sync: examples/$file" >&2
    exit 1
  }
done

document_types=(notice request joint letter order minutes campus)
for document_type in "${document_types[@]}"; do
  "$skill_root/scripts/init-document.sh" \
    --type "$document_type" \
    --output "$tmp_root/generated-$document_type" >/dev/null
  [[ -s "$tmp_root/generated-$document_type/document.tex" ]] || {
    echo "error: initializer did not create type $document_type" >&2
    exit 1
  }
done

make -C "$tmp_root/generated-notice" >/dev/null
[[ -s "$tmp_root/generated-notice/build/document.pdf" ]] || {
  echo "error: isolated generated document did not build" >&2
  exit 1
}

checksum_before="$(sha256sum "$tmp_root/generated-notice/document.tex")"
if "$skill_root/scripts/init-document.sh" \
  --type request \
  --output "$tmp_root/generated-notice" >/dev/null 2>&1; then
  echo "error: initializer overwrote an existing project" >&2
  exit 1
fi
checksum_after="$(sha256sum "$tmp_root/generated-notice/document.tex")"
[[ "$checksum_before" == "$checksum_after" ]] || {
  echo "error: initializer changed a file after refusing overwrite" >&2
  exit 1
}

make clean

echo "All SYSURedHead checks passed."
