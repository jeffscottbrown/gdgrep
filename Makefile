BINARY  := gdgrep
SRCS    := src/version.jer src/grep.jer src/main.jer
PREFIX  ?= /usr/local
VERSION := $(shell git describe --tags --always 2>/dev/null || echo "dev")

.PHONY: all build run test clean install uninstall help

all: build

src/version.jer:
	@printf 'let VERSION: string = "%s";\n' "$(VERSION)" > src/version.jer

## build     compile the gdgrep binary
build: src/version.jer $(BINARY)

$(BINARY): $(SRCS)
	jerry compile $(SRCS) -o $(BINARY)

## test       run unit tests with Jerry's built-in test runner
test:
	jerry test src/

## run        run without a persistent binary  (usage: make run ARGS="-n fn src/main.jer")
run: $(SRCS)
	jerry run $(SRCS) $(ARGS)

## install    install gdgrep to $(PREFIX)/bin  (default: /usr/local/bin)
install: $(BINARY)
	install -d $(PREFIX)/bin
	install -m 755 $(BINARY) $(PREFIX)/bin/$(BINARY)

## uninstall  remove gdgrep from $(PREFIX)/bin
uninstall:
	rm -f $(PREFIX)/bin/$(BINARY)

## clean      remove build artifacts
clean:
	rm -f $(BINARY) src/version.jer

## help       show this help
help:
	@grep -E '^## ' Makefile | awk '{$$1=""; printf "  %-12s %s\n", $$2, substr($$0, index($$0,$$3))}'
