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

Install SpotScanner with the fully qualified formula name:

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

SpotScanner 8.0.1 revision 1 uses Python 3.15, matching the current Homebrew
OpenCV bindings. Its virtual environment shares Homebrew's NumPy and OpenCV.
The upstream pip package retains its exact NumPy and `opencv-python-headless`
pins for reproducibility; the Formula deliberately installs the package with
`--no-deps` and uses Homebrew's native libraries instead. The two distribution
runtimes are validated separately. A pip dependency-version assertion or
`pip check` against the upstream metadata is not a Homebrew compatibility test.

For an existing installation, after this change reaches the tap's default
branch:

```bash
brew update
brew upgrade KentoYana/tap/spotscanner
brew test KentoYana/tap/spotscanner
```

The Formula revision makes the fix upgradeable without changing the upstream
8.0.1 release. `spotscanner --version` therefore continues to show 8.0.1;
`brew list --versions spotscanner` shows the packaging revision as `8.0.1_1`.

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
