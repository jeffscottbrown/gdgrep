BINARY := gdgrep
SRCS   := src/strings.jer src/grep.jer src/main.jer
PREFIX ?= /usr/local

.PHONY: all build run clean install uninstall help

all: build

## build     compile the gdgrep binary
build: $(BINARY)

$(BINARY): $(SRCS)
	jerry compile $(SRCS) -o $(BINARY)

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
	rm -f $(BINARY)

## help       show this help
help:
	@grep -E '^## ' Makefile | awk '{$$1=""; printf "  %-12s %s\n", $$2, substr($$0, index($$0,$$3))}'
