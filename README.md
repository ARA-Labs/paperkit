# paperkit

One LaTeX preamble for ML papers. Copy this folder, write your paper, and switch
venue with a single word:

![arXiv preprint output](docs/preview-arxiv.png)


```latex
\usepackage[arxiv]{styles/paperkit}     % preprint, two-column, rounded title panel
\usepackage[neurips]{styles/paperkit}   % NeurIPS 2026 submission (anonymous)
\usepackage[icml]{styles/paperkit}      % ICML 2026 submission (anonymous)
\usepackage[plain]{styles/paperkit}     % plain article, no venue style
```

The same `main.tex` and the same `sections/*.tex` compile in every mode. Nothing
else in the document changes.

## Quick start

```bash
cp -r paperkit my-paper && cd my-paper
make            # arXiv preprint  -> main.pdf
make neurips    # NeurIPS submission
make icml       # ICML submission
make plain      # no venue style
make FINAL=1 neurips    # camera-ready, de-anonymized
make clean
```

`make <venue>` also drops a copy at `build/main-<venue>.pdf`, so you can keep the
preprint and the submission side by side.

The Makefile sets the venue on the command line, so you never have to edit
`main.tex` to switch. If you compile by hand or on Overleaf, edit the
`\usepackage[...]` line instead.

## Front matter

Set these in the preamble; only the title is required. `\makepaperheader`
renders whichever first page the venue calls for.

```latex
\papertitle[Plain title for PDF metadata]{Typeset Title:\\Second Line}
\paperrunningtitle{Short Title for the Header}
\paperauthors{First Author\textsuperscript{1,\,*}, Second Author\textsuperscript{2}}
\paperaffiliations{\textsuperscript{1}Your University, \textsuperscript{2}Your Lab}
\papernote{\textsuperscript{*}Equal contribution.}
\paperabstract{\input{sections/abstract}}
\papercorrespondence{First Author (\href{mailto:you@example.edu}{you@example.edu})}
\papercode{\href{https://github.com/you/repo}{github.com/you/repo}}
\paperlogo{Your Lab}{figures/logo-placeholder.pdf}   % either argument may be empty
\addpaperlogo[26pt]{figures/partner-logo.pdf}        % repeat for more marks

\begin{document}
\makepaperheader
```

Keep `sections/abstract.tex` as raw body text with no `\begin{abstract}` wrapper.
That is what lets the same file go into the panel for the preprint and into the
venue's abstract environment for the submission.

## What each venue mode gives you

| Option | Style file | Columns | Anonymous | First page |
| --- | --- | --- | --- | --- |
| `arxiv` (default) | `icml2026` + `preprint` | two | no | rounded panel |
| `icml` | `icml2026` | two | yes (until `final`) | ICML title block |
| `neurips` | `neurips_2026` | one | yes (until `final`) | NeurIPS title block |
| `neurips2025` | `neurips_2025` | one | yes (until `final`) | NeurIPS title block |
| `plain` | none | one | no | `\maketitle` |

## Package options

| Option | Effect |
| --- | --- |
| `final` | Camera-ready: de-anonymize, print the conference notice |
| `preprint` | NeurIPS style in preprint mode (named authors, no notice) |
| `panel` / `nopanel` | Force the rounded title panel on or off |
| `colorlinks` | Colored hyperlinks instead of boxed ones |
| `notheorems` | Skip the theorem environments |
| `minimal` | Skip tikz, listings, and pifont for faster compiles |

Two knobs live outside the option list, because they have to be set before the
package loads:

```latex
\def\pkstyledir{mystyles/}      % where the venue .sty files live (default: styles/)
\def\pkneuripstrack{position}   % NeurIPS camera-ready track: main (default), position, eandd, creativeai
\usepackage[neurips]{styles/paperkit}
```

## The title panel

`panel` mode puts the title, authors, affiliations, abstract, correspondence,
and a lab wordmark into a single rounded box above the two-column body, the
layout most industry-lab preprints use. It is on by default for `arxiv` and
available anywhere with the `panel` option.

```latex
\paperpanelcolor{EEF3F9}   % background hex (default: soft blue-gray)
\paperpanelarc{8pt}        % corner radius
\papertitlesize{19}{23}    % title font size and leading, in pt
\paperlogoheight{30pt}     % default height for logos
```

### Logos

The panel footer puts the correspondence and code lines on the left and the
wordmark plus any number of logos on the right, all vertically centered:

```latex
\paperlogo{Your Lab}{figures/logo-placeholder.pdf}
\addpaperlogo{figures/university.pdf}
\addpaperlogo[22pt]{figures/company.pdf}    % optional per-logo height
```

Drop the wordmark with `\paperlogo{}{...}`, or the image with
`\paperlogo{Your Lab}{}`. Vector logos (PDF, EPS) stay crisp at any size; PNG
works too if that is what your affiliation ships.

`figures/logo-placeholder.pdf` is a neutral stand-in so the template renders
out of the box. Replace it with your real mark, or rebuild a different one from
`figures/logo-placeholder.tex` (`pdflatex logo-placeholder.tex`).

In anonymous mode the panel prints "Anonymous Authors" and drops the
correspondence row on its own, so a blind submission stays blind even if you
force `panel` on.

## What the package already loads

You do not need to re-`\usepackage` any of these: `microtype`, `graphicx`,
`subcaption`, `booktabs`, `multirow`, `amsmath`, `amssymb`, `amsthm`,
`nicefrac`, `xcolor`, `enumitem`, `placeins`, `hyperref`, `natbib`, `url`,
`tcolorbox`, `helvet`, plus `listings`, `tikz`, and `pifont` unless you asked
for `minimal`. `stfloats` is added in two-column modes so `figure*` can sit at
the bottom of a page.

It also defines `\cmark`, `\xmark`, `\todo{...}`, a `lstset` style for code
listings, and the usual theorem environments (`theorem`, `lemma`,
`proposition`, `corollary`, `definition`, `assumption`, `remark`).

Put your own macros in `main.tex` after the `\usepackage` line.

## Overleaf

Upload the whole folder (or push this repo to Overleaf via GitHub) and compile.
Nothing needs to change:

- **Set the venue in the `\usepackage[...]` line.** Overleaf does not run the
  Makefile, so the command-line venue switch is not available there.
- Compiler: **pdfLaTeX** (Overleaf's default), main document `main.tex`.
- Every package paperkit pulls in is stock TeX Live, and nothing needs
  `--shell-escape`.
- `\usepackage{styles/paperkit}` and the venue styles under `styles/` resolve
  relative to `main.tex`, which is how Overleaf compiles.
- Bibliography is plain BibTeX, which Overleaf runs automatically.

## When to bypass paperkit

For an ICML or NeurIPS camera-ready with a long author list, the venue's own
author macros (`\icmlauthorlist`, `\icmlaffiliation`, or NeurIPS's `\And`)
produce the exact block the proceedings expect. paperkit does not wrap them.
Pass `nopanel`, write that block yourself in `main.tex`, and skip
`\makepaperheader`; everything else in the package still applies.

## Files

```
main.tex            your paper: front matter + \input list
sections/           abstract.tex, introduction.tex, appendix.tex
references.bib      bibliography
figures/            put figures here; ships a placeholder logo + its TikZ source
styles/paperkit.sty the package
styles/icml2026.sty, neurips_2026.sty, neurips_2025.sty, icml2026.bst
Makefile            make arxiv | icml | neurips | plain, FINAL=1 for camera-ready
```

`\bibliographystyle{plainnat}` is the default and works everywhere. For an ICML
camera-ready, switch to `\bibliographystyle{styles/icml2026}`.

## License

The wrapper (`styles/paperkit.sty`, the `Makefile`, and the template files) is
MIT licensed: copy, modify, and redistribute it freely. The bundled conference
style files are the property of their respective conferences and are included
only so the template compiles out of the box; always re-download the current
year's official copy before submitting. See [LICENSE](LICENSE).
