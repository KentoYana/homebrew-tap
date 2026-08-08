# Homebrew Tap

Homebrew formulae maintained by Kento Yanagisawa.

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
