LATEXMK ?= latexmk
ROOT_SOURCE ?= $(if $(wildcard RedHead.tex),RedHead.tex,document.tex)
EXAMPLE_SOURCES := $(sort $(wildcard examples/*.tex))
ALL_SOURCES := $(ROOT_SOURCE) $(EXAMPLE_SOURCES)
TEST_SOURCES := $(sort $(wildcard tests/*.tex))
TEST_PDFS := $(patsubst tests/%.tex,build/%.pdf,$(TEST_SOURCES))
ROOT_RUNNER ?= ./scripts/with-texlive-fonts.sh

.PHONY: all root examples check clean

all: examples

root:
	@if test -x "$(ROOT_RUNNER)"; then \
		"$(ROOT_RUNNER)" $(LATEXMK) "$(ROOT_SOURCE)"; \
	else \
		$(LATEXMK) "$(ROOT_SOURCE)"; \
	fi

examples: root
	@set -eu; \
	for source in $(EXAMPLE_SOURCES); do \
		$(LATEXMK) "$$source"; \
	done

check:
	./scripts/check.sh

clean:
	@if test -d build; then \
		find build -mindepth 1 -maxdepth 1 -type f ! -name '*.pdf' -delete; \
		for pdf in $(TEST_PDFS); do rm -f -- "$$pdf"; done; \
		rmdir build 2>/dev/null || true; \
	fi
