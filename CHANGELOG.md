## 1.0.1

- Added high-resolution iOS Simulator showcase screenshots (`pubspec.yaml` gallery & `README.md`), multi-line block intraline highlight pairing, and enhanced code diff + ANSI log console showcase.

## 1.0.0

- **Initial Stable Release of `zero_diff` by RedLight Apps (`https://redlightapps.com`).**
- **Myers $O(ND)$ Shortest Edit Script Engine (`MyersDiffEngine`):** Line-by-line and word-level intraline diffing (`computeIntralineSpans`) with automatic background `Isolate.run` offloading and Unified Git Patch generation (`toUnifiedPatch`).
- **120Hz Virtualized Code/Text Diff Viewer (`ZeroDiffViewer`):** Instant switching between `DiffViewMode.unified` and synchronized `DiffViewMode.sideBySide` views with +/- change summary badges.
- **120Hz Virtualized ANSI Streaming Log Console (`ZeroLogConsole`, `AnsiLogParser`):** Renders 100,000+ streaming CI/CD or telemetry log lines with ANSI color decoding, severity filtering, and instant search.
