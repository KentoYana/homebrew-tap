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
