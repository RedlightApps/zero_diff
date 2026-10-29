# `zero_diff` — English Developer Guide

## 1. Overview
`zero_diff` is a 120Hz code/text diff viewer and virtualized ANSI log console engine for Flutter engineered by **RedLight Apps** (`https://redlightapps.com`) with zero external dependencies.

## 2. Core Modules
- **`MyersDiffEngine`:** Line and word-level intraline diffing (`compute`, `computeAsync`, `computeIntralineSpans`, `toUnifiedPatch`).
- **`ZeroDiffViewer`:** Virtualized `unified` and `sideBySide` diff comparison widget.
- **`ZeroLogConsole` & `AnsiLogParser`:** 100,000+ line ANSI color log viewer with instant filtering.
