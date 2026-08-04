# paperkit -- build the paper in any venue mode.
#
#   make            # same as `make arxiv'
#   make neurips    # NeurIPS submission (anonymous)
#   make icml       # ICML submission (anonymous)
#   make plain      # plain article, no venue style
#   make FINAL=1 neurips     # camera-ready / de-anonymized
#   make clean      # remove build artifacts
#
# Each target writes main.pdf and keeps a copy as build/main-<venue>.pdf.

MAIN   ?= main
VENUE  ?= arxiv
FINAL  ?=

LATEX  = pdflatex -interaction=nonstopmode -halt-on-error
BIBTEX = bibtex

# Extra paperkit options, e.g. `make OPTS=panel,colorlinks neurips'.
OPTS ?=
ifeq ($(FINAL),1)
  ifeq ($(strip $(OPTS)),)
    ALLOPTS := final
  else
    ALLOPTS := final,$(OPTS)
  endif
else
  ALLOPTS := $(OPTS)
endif

ifeq ($(strip $(ALLOPTS)),)
  PKOPTS =
else
  PKOPTS = \PassOptionsToPackage{$(ALLOPTS)}{styles/paperkit}
endif

.PHONY: all arxiv icml neurips neurips2025 plain build clean distclean

all: arxiv

arxiv icml neurips neurips2025 plain:
	@$(MAKE) --no-print-directory build VENUE=$@

build:
	$(LATEX) "$(PKOPTS)\def\pkvenue{$(VENUE)}\input{$(MAIN).tex}"
	-$(BIBTEX) $(MAIN)
	$(LATEX) "$(PKOPTS)\def\pkvenue{$(VENUE)}\input{$(MAIN).tex}"
	$(LATEX) "$(PKOPTS)\def\pkvenue{$(VENUE)}\input{$(MAIN).tex}"
	@mkdir -p build
	@cp $(MAIN).pdf build/$(MAIN)-$(VENUE).pdf
	@echo "==> $(MAIN).pdf (venue: $(VENUE)) and build/$(MAIN)-$(VENUE).pdf"

clean:
	rm -f $(MAIN).aux $(MAIN).log $(MAIN).out $(MAIN).bbl $(MAIN).blg \
	      $(MAIN).fls $(MAIN).fdb_latexmk $(MAIN).synctex.gz $(MAIN).toc \
	      $(MAIN).brf $(MAIN).nav $(MAIN).snm $(MAIN).vrb

distclean: clean
	rm -f $(MAIN).pdf
	rm -rf build
