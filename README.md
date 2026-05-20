# gdgrep

[![CI](https://github.com/jeffscottbrown/gdgrep/actions/workflows/ci.yml/badge.svg)](https://github.com/jeffscottbrown/gdgrep/actions/workflows/ci.yml)
[![Release](https://github.com/jeffscottbrown/gdgrep/actions/workflows/release.yml/badge.svg)](https://github.com/jeffscottbrown/gdgrep/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/jeffscottbrown/gdgrep)](https://github.com/jeffscottbrown/gdgrep/releases/latest)

A grep tool for searching files and standard input.

```sh
gdgrep [flags] <pattern> [file ...]
```

gdgrep is a proof of concept project implemented in the experimental [Jerry](https://github.com/jeffscottbrown/jerry-lang) language.

## Installation

### Homebrew (macOS and Linux)

```sh
brew tap jeffscottbrown/gdgrep
brew install gdgrep
```

### Download a pre-built binary

Pre-built binaries for macOS (arm64, x86\_64) and Linux (x86\_64) are on the
[Releases page](https://github.com/jeffscottbrown/gdgrep/releases/latest).

```sh
# Example — macOS Apple Silicon
curl -fsSL https://github.com/jeffscottbrown/gdgrep/releases/latest/download/gdgrep-macos-arm64.tar.gz | tar -xz
sudo mv gdgrep-macos-arm64 /usr/local/bin/gdgrep
```

Verify the download:

```sh
sha256sum --check --ignore-missing checksums.txt
```

### Build from source

Requires [Jerry](https://github.com/jeffscottbrown/jerry-lang) and **clang**.

```sh
git clone https://github.com/jeffscottbrown/gdgrep.git
cd gdgrep
make install          # installs to /usr/local/bin by default
# or: make install PREFIX=~/.local
```

## Usage

```
gdgrep [--color] [-A N] [-B N] [-C N] [-c] [-h] [-H] [-i] [-l] [-L] [-m N] [-n] [-q] [-v] [-V] <pattern> [file ...]
```

Flags must appear before the pattern and may be given in any order.

When no files are given, `gdgrep` reads from standard input.
Exits with status 1 when no lines match, compatible with shell pipelines.

### Flags

| Flag | Description |
|------|-------------|
| `--color` | Highlight the matched portion in bold red |
| `-A N` | Print N lines of trailing context after each match |
| `-B N` | Print N lines of leading context before each match |
| `-C N` | Print N lines of context before and after each match |
| `-c` | Print only a count of matching lines per file |
| `-h` | Suppress the filename prefix on output lines |
| `-H` | Always print the filename prefix on output lines |
| `-i` | Case-insensitive matching |
| `-l` | Print only the names of files with at least one match |
| `-L` | Print only the names of files with no matches |
| `-m N` | Stop after N matching lines |
| `-n` | Prefix each matching line with its 1-based line number |
| `-q` | Quiet: suppress output, exit 0 if any match found |
| `-v` | Invert match: print lines that do NOT contain the pattern |
| `-V` | Print version and exit |

## Examples

```sh
# Basic search
gdgrep error app.log

# Case-insensitive with line numbers
gdgrep -i -n error app.log

# Highlight matches in color
gdgrep --color TODO src/main.jer

# Show 2 lines of context around each match
gdgrep -C 2 panic server.log

# Count matches per file
gdgrep -c error *.log

# List only files that contain a match
gdgrep -l TODO src/*.jer

# Invert: print lines that do NOT match
gdgrep -v DEBUG app.log

# Stop after the first 5 matches
gdgrep -m 5 error app.log

# Pipeline
cat access.log | gdgrep 404
```

## License

Apache 2

---

For information on building, testing, and contributing to gdgrep, see [CONTRIBUTING.md](CONTRIBUTING.md).
