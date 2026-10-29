# `zero_diff` — Architecture & Algorithm Reference

## 1. Longest Common Subsequence & Intraline Token Diff (`MyersDiffEngine`)

Given source lines $A = [a_0, \dots, a_{n-1}]$ and target lines $B = [b_0, \dots, b_{m-1}]$, `MyersDiffEngine` computes the minimal edit sequence of `equal`, `delete`, and `insert` operations. Adjacent `(delete, insert)` line pairs are tokenized via `RegExp(r'(\s+|\w+|[^\s\w]+)')` to produce word-level `DiffSpan` highlights (`computeIntralineSpans`).

## 2. ANSI SGR Escape Code Parser (`AnsiLogParser`)

`AnsiLogParser.parse` scans log lines in a single linear pass using `RegExp(r'\x1B\[(\d+)m')`, mapping standard SGR foreground codes (`31–36`, `91–96`) to high-contrast terminal colors while `ZeroLogConsole` renders rows with fixed `itemExtent` virtualization.
