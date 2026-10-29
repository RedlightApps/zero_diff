import 'package:flutter/material.dart';

/// Edit operation kind computed by `MyersDiffEngine`.
enum DiffOpType {
  /// Unchanged line or token present in both old and new versions.
  equal,

  /// Line or token deleted from the old version (`-`).
  delete,

  /// Line or token inserted into the new version (`+`).
  insert,
}

/// Presentation layout mode for `ZeroDiffViewer`.
enum DiffViewMode {
  /// Single-column interleaved diff view (`git diff` style).
  unified,

  /// Synchronized two-column split diff view (GitHub / VS Code style).
  sideBySide,
}

/// Word or character-level segment within a modified line.
class DiffSpan {
  /// Creates a [DiffSpan].
  const DiffSpan({
    required this.text,
    required this.type,
  });

  /// Segment substring.
  final String text;

  /// Operation type (`equal`, `delete`, or `insert`).
  final DiffOpType type;
}

/// Single line entry produced by `MyersDiffEngine`.
class DiffLine {
  /// Creates a [DiffLine].
  const DiffLine({
    required this.type,
    required this.content,
    this.oldLineNumber,
    this.newLineNumber,
    this.intralineSpans = const [],
  });

  /// Operation type (`equal`, `delete`, or `insert`).
  final DiffOpType type;

  /// Raw text content of the line.
  final String content;

  /// 1-based line number in the original text (`null` for pure insertions).
  final int? oldLineNumber;

  /// 1-based line number in the updated text (`null` for pure deletions).
  final int? newLineNumber;

  /// Optional word-level intraline highlight spans for modified line pairs.
  final List<DiffSpan> intralineSpans;

  /// Prefix symbol (`' '`, `'-'`, or `'+'`).
  String get prefixSymbol => switch (type) {
        DiffOpType.equal => ' ',
        DiffOpType.delete => '-',
        DiffOpType.insert => '+',
      };
}

/// Complete diff computation result including line entries and statistics.
class DiffSummary {
  /// Creates a [DiffSummary].
  const DiffSummary({
    required this.lines,
    required this.addedCount,
    required this.deletedCount,
    required this.unchangedCount,
  });

  /// Ordered list of diff lines.
  final List<DiffLine> lines;

  /// Total number of inserted lines (`+`).
  final int addedCount;

  /// Total number of deleted lines (`-`).
  final int deletedCount;

  /// Total number of unchanged lines.
  final int unchangedCount;
}

/// Visual theme configuration for `ZeroDiffViewer` and `ZeroLogConsole`.
class ZeroDiffTheme {
  /// Creates a [ZeroDiffTheme].
  const ZeroDiffTheme({
    this.backgroundColor = const Color(0xFF0A0D14),
    this.headerBackgroundColor = const Color(0xFF111726),
    this.borderColor = const Color(0xFF1E293B),
    this.addedLineColor = const Color(0x2200E676),
    this.deletedLineColor = const Color(0x22FF1744),
    this.addedWordHighlight = const Color(0x5500E676),
    this.deletedWordHighlight = const Color(0x55FF1744),
    this.addedTextColor = const Color(0xFF00E676),
    this.deletedTextColor = const Color(0xFFFF5252),
    this.codeTextStyle = const TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: Color(0xFFE2E8F0),
    ),
    this.lineNumberStyle = const TextStyle(
      fontFamily: 'monospace',
      fontSize: 11.5,
      color: Color(0xFF64748B),
    ),
  });

  /// Main canvas background color.
  final Color backgroundColor;

  /// Toolbar header background color.
  final Color headerBackgroundColor;

  /// Hairline divider color.
  final Color borderColor;

  /// Row background tint for inserted lines.
  final Color addedLineColor;

  /// Row background tint for deleted lines.
  final Color deletedLineColor;

  /// Word-level intraline highlight color for inserted tokens.
  final Color addedWordHighlight;

  /// Word-level intraline highlight color for deleted tokens.
  final Color deletedWordHighlight;

  /// Accent color for `+` badges and text.
  final Color addedTextColor;

  /// Accent color for `-` badges and text.
  final Color deletedTextColor;

  /// Monospace text style for code and log lines.
  final TextStyle codeTextStyle;

  /// Monospace text style for gutter line numbers.
  final TextStyle lineNumberStyle;
}
