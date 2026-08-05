#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out=$(mktemp -d "${TMPDIR:-/tmp}/paperkit-tests.XXXXXX")
trap 'rm -rf "$out"' EXIT HUP INT TERM

compile_fixture() {
  fixture=$1
  venue=$2
  mode=$3
  job="paperkit-${venue}-${mode}"
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

for venue in arxiv icml neurips neurips2025 plain
do
  compile_fixture tests/paperkit-natbib.tex "$venue" natbib
  compile_fixture tests/paperkit-biblatex.tex "$venue" biblatex
done
