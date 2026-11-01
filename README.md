# Homebrew Tap

Homebrew formulae maintained by Kento Yanagisawa.

## codex-notify

Play local macOS sounds when Codex requests approval or completes a turn:

```bash
brew install KentoYana/tap/codex-notify
codex-notify install
brew services start codex-notify
```

See [KentoYana/codex-notify](https://github.com/KentoYana/codex-notify)
for configuration and troubleshooting.

## BibCollect

Collect exported `.bib`, `.bibtex`, and `.ris` files into a single
`today.bib`, while organizing associated PDF files:

```bash
brew install KentoYana/tap/bibcollect
bibcollect --path ~/Downloads/citations
```

See [KentoYana/BibCollect](https://github.com/KentoYana/BibCollect) for usage
and release notes.

## SpotScanner

Install SpotScanner 8.0.2 with the fully qualified formula name:

```bash
brew install KentoYana/tap/spotscanner
```

Alternatively, tap the repository first:

```bash
brew tap KentoYana/tap
brew trust --formula KentoYana/tap/spotscanner
brew install spotscanner
```

The formula uses Homebrew-managed Python, NumPy, and OpenCV. It does not use or
modify the user's system Python, pyenv installations, or global pip packages.

### SpotScanner dependency policy and verification

SpotScanner 8.0.2 uses Python 3.15, matching the current Homebrew
OpenCV bindings. Its virtual environment shares Homebrew's NumPy and OpenCV.
The upstream pip package retains its exact NumPy and `opencv-python-headless`
pins for reproducibility; the Formula deliberately installs the package with
`--no-deps` and uses Homebrew's native libraries instead. The two distribution
runtimes are validated separately. A pip dependency-version assertion or
`pip check` against the upstream metadata is not a Homebrew compatibility test.

Update and verify an existing installation:

```bash
brew update
brew upgrade KentoYana/tap/spotscanner
brew test KentoYana/tap/spotscanner
```

The Python compatibility fix first shipped as SpotScanner `8.0.1_1`
(8.0.1 revision 1). Release 8.0.2 retains that fix and the same analysis tests.
`spotscanner --version` reports `8.0.2`, and
`brew list --versions spotscanner` includes `8.0.2`. The newer upstream version
upgrades existing `8.0.1_1` installations.

The [SpotScanner Homebrew workflow](.github/workflows/spotscanner.yml) runs on
macOS for Formula or workflow changes, every January 1 and July 1 at
03:23 UTC (12:23 JST), and through **Actions → SpotScanner Homebrew → Run workflow**. It refreshes
Homebrew metadata, registers and verifies the exact checked-out tap commit,
checks that OpenCV and SpotScanner declare the same Python minor version,
installs current dependencies and the Formula, imports the installed runtime,
and runs `brew test` for both analysis modes. The test checks generated images,
CSV structure, coordinates, and numerical results. Runtime versions, paths,
and installation/test logs are retained as workflow artifacts for 30 days.

Scheduled runs use the default branch. The workflow uses targeted dependency
installation, without a global `brew upgrade` or cleanup. It supplements the
application repository's pip CI; synthetic tests do not replace the real-image
regression procedure documented in the application repository.

When Homebrew changes OpenCV's Python minor version, review the failure and
update the Formula's Python dependency and venv interpreter together, increment
the Formula revision, and rerun both `brew test` and real-image regression.
Do not loosen pip pins or numerical expectations merely to make CI pass.

## BibDesk RAG

Search a BibDesk library, PDFs and supplementary files from Codex using a local,
read-only MCP server:

```bash
brew install KentoYana/tap/bibdesk-rag
```

Codex CLI is optional. For command-line registration, check `codex --version`.
If the command is missing, install the CLI first:

```bash
brew install --cask codex
codex --version
```

You can also register the MCP server through the app settings without installing
the CLI; see the [Codex connection guide](https://github.com/KentoYana/BibDeskRAG/blob/main/docs/codex.md).

Follow the [BibDesk RAG setup guide](https://github.com/KentoYana/BibDeskRAG#homebrewで導入してcodexから使う)
to register your own `.bib`, build its local index, and connect Codex to
`bibdesk-rag-mcp`. The Formula uses Homebrew-managed Python in its own environment;
users do not need to configure pyenv or global pip. Original libraries and linked
files remain read-only. Configuration and indexes are stored outside the Cellar
and are retained during upgrades and uninstall.

Update and verify an existing installation:

```bash
brew update
brew upgrade KentoYana/tap/bibdesk-rag
brew test KentoYana/tap/bibdesk-rag
```

To stop using BibDesk RAG, remove its MCP registration with
`codex mcp remove bibdesk-rag` or through the app settings, close active Codex/MCP
sessions, then run:

```bash
brew uninstall KentoYana/tap/bibdesk-rag
```

This removes the application and its dedicated Python environment. Your BibDesk
originals, configuration and search index remain. See the
[removal guide](https://github.com/KentoYana/BibDeskRAG#アンインストール)
for optional removal of derived data and of a Codex CLI installed only for this
tool. Keep the shared tap and other packages if you still use them.

The [BibDesk RAG Homebrew workflow](.github/workflows/bibdesk-rag.yml) runs on macOS
when its Formula or workflow changes, and through **Actions → BibDesk RAG Homebrew
→ Run workflow**. It registers and verifies the checked-out tap commit, checks
the Formula, installs from source, and runs CLI/MCP retrieval tests using generated
PDF and CSV fixtures. Tests verify source preservation and PDF page citations;
they do not require a personal library. Logs are retained for 30 days.
