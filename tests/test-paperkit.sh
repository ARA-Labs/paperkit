#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out=$(mktemp -d "${TMPDIR:-/tmp}/paperkit-tests.XXXXXX")
trap 'rm -rf "$out"' EXIT HUP INT TERM

compile_fixture() {
  fixture=$1
  venue=$2
  mode=$3
  # `venue' may carry extra options, e.g. arxiv1col,acmtrim -- keep the
  # commas out of the job name.
  job="paperkit-$(printf '%s' "$venue" | tr ',' '-')-${mode}"
  printf 'Compiling %s (%s)... ' "$venue" "$mode"
  if (cd "$repo" && pdflatex -interaction=batchmode -halt-on-error \
      -output-directory="$out" -jobname="$job" \
      "\\def\\paperkitvenue{$venue}\\input{$fixture}")
  then
    printf 'ok\n'
  else
    printf 'failed\n'
    command cat "$out/$job.log"
    return 1
  fi
}

for venue in arxiv arxiv1col icml neurips neurips2025 plain
do
  compile_fixture tests/paperkit-natbib.tex "$venue" natbib
  compile_fixture tests/paperkit-biblatex.tex "$venue" biblatex
done

# The one-column venue's second page geometry, and its no-Libertine fallback.
compile_fixture tests/paperkit-natbib.tex arxiv1col,acmtrim natbib
compile_fixture tests/paperkit-natbib.tex arxiv1col,nolibertine natbib

# The branded head and foot: switched off, and on over the native title block
# rather than the panel.
compile_fixture tests/paperkit-natbib.tex arxiv1col,noheader natbib
compile_fixture tests/paperkit-natbib.tex arxiv1col,nopanel natbib

# The code link must survive arxiv1col,nopanel: it renders under the native
# abstract, and no footer carries it anymore. A compile-only pass cannot see
# the difference, so extract the text and look.
if command -v pdftotext >/dev/null 2>&1; then
  printf 'Checking arxiv1col,nopanel renders the code link... '
  if pdftotext "$out/paperkit-arxiv1col-nopanel-natbib.pdf" - 2>/dev/null | grep -q 'Code:'; then
    printf 'ok\n'
  else
    printf 'MISSING\n'
    exit 1
  fi
fi
