# gdgrep

[![CI](https://github.com/jeffscottbrown/gdgrep/actions/workflows/ci.yml/badge.svg)](https://github.com/jeffscottbrown/gdgrep/actions/workflows/ci.yml)
[![Release](https://github.com/jeffscottbrown/gdgrep/actions/workflows/release.yml/badge.svg)](https://github.com/jeffscottbrown/gdgrep/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/jeffscottbrown/gdgrep)](https://github.com/jeffscottbrown/gdgrep/releases/latest)

A fast, friendly grep written in [Jerry](https://github.com/jeffscottbrown/jerry-lang) — a statically-typed, JavaScript-style language that compiles to native binaries via LLVM IR.

```sh
gdgrep [-i] [-n] <pattern> [file ...]
```

## Features

- Literal string search across files or stdin
- `-i` — case-insensitive matching
- `-n` — prefix each matching line with its 1-based line number
- Multi-file label output (`filename:line`) when more than one file is given
- Exits with status 1 when no lines match, compatible with shell pipelines

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

Verify the download against `checksums.txt` (also on the release page):

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
gdgrep [-i] [-n] <pattern> [file ...]
```

| Flag | Description |
|------|-------------|
| `-i` | Case-insensitive matching (ASCII fold) |
| `-n` | Prefix each matching line with its line number |

Flags must appear before the pattern.  They may be given in any order or
combined as separate arguments (e.g. `-i -n` or `-n -i`).

When no files are given, `gdgrep` reads from standard input.

## Examples

```sh
# Basic search
gdgrep error app.log

# Case-insensitive
gdgrep -i error app.log

# Show line numbers
gdgrep -n TODO src/main.jer

# Combined flags, multiple files
gdgrep -i -n fn src/strings.jer src/grep.jer src/main.jer

# Pipeline
cat access.log | gdgrep 404
```

## Project layout

```
gdgrep/
├── src/
│   ├── strings.jer     # to_lower, contains — pure string utilities
│   ├── grep.jer        # grep_lines — core search logic
│   └── main.jer        # entry point: flag parsing, dispatch
├── homebrew/
│   └── gdgrep.rb       # Homebrew formula template (tokens filled by CI)
├── .github/
│   └── workflows/
│       ├── ci.yml      # build + test on every push / PR
│       └── release.yml # publish binaries + update tap on v*.*.* tags
├── Makefile
└── README.md
```

Source files are compiled together in a single `jerry compile` invocation.
Functions defined in any `.jer` file are visible to all other files in the
same build — no explicit imports between project files are needed.

## Homebrew tap setup

The Homebrew formula lives in a separate
[jeffscottbrown/homebrew-gdgrep](https://github.com/jeffscottbrown/homebrew-gdgrep)
repository.  On every stable release the CI workflow:

1. Copies `homebrew/gdgrep.rb` (the template) into the tap repo.
2. Replaces `VERSION_PLACEHOLDER` and `SHA256_*` tokens with the tag and
   the SHA256 of each platform archive.
3. Commits and pushes to `homebrew-gdgrep`.

To wire this up for the first time:

1. Create `https://github.com/jeffscottbrown/homebrew-gdgrep` with a
   `Formula/` directory containing `gdgrep.rb` copied from `homebrew/gdgrep.rb`.
2. Create a fine-grained GitHub PAT scoped to **homebrew-gdgrep** with
   **Contents: Read and Write**.
3. Add the PAT as secret `HOMEBREW_TAP_TOKEN` in the **gdgrep** repo
   (Settings → Secrets and variables → Actions).
4. Push a `v*.*.*` tag to trigger the first release.

## License

Apache 2
