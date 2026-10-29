import 'dart:isolate';
import 'package:zero_diff/src/model/diff_models.dart';

/// High-speed Myers $O(ND)$ / LCS diff engine with word-level intraline
/// highlighting, background [Isolate] offloading, and Unified Patch export.
abstract final class MyersDiffEngine {
  /// Computes a full [DiffSummary] between [oldText] and [newText]
  /// synchronously.
  static DiffSummary compute(
    String oldText,
    String newText, {
    bool computeIntraline = true,
  }) {
    final oldLines = _splitLines(oldText);
    final newLines = _splitLines(newText);
    final rawOps = _diffSequences<String>(oldLines, newLines);

    var oldNo = 1;
    var newNo = 1;
    var added = 0;
    var deleted = 0;
    var unchanged = 0;
    final rawDiffLines = <DiffLine>[];

    for (final op in rawOps) {
      switch (op.$1) {
        case DiffOpType.equal:
          unchanged++;
          rawDiffLines.add(
            DiffLine(
              type: DiffOpType.equal,
              content: op.$2,
              oldLineNumber: oldNo++,
              newLineNumber: newNo++,
            ),
          );
        case DiffOpType.delete:
          deleted++;
          rawDiffLines.add(
            DiffLine(
              type: DiffOpType.delete,
              content: op.$2,
              oldLineNumber: oldNo++,
            ),
          );
        case DiffOpType.insert:
          added++;
          rawDiffLines.add(
            DiffLine(
              type: DiffOpType.insert,
              content: op.$2,
              newLineNumber: newNo++,
            ),
          );
      }
    }

    if (computeIntraline) {
      _attachIntralineHighlights(rawDiffLines);
    }

    return DiffSummary(
      lines: List<DiffLine>.unmodifiable(rawDiffLines),
      addedCount: added,
      deletedCount: deleted,
      unchangedCount: unchanged,
    );
  }

  /// Computes a [DiffSummary] on a background [Isolate] when total lines exceed
  /// [isolateThreshold].
  static Future<DiffSummary> computeAsync(
    String oldText,
    String newText, {
    bool computeIntraline = true,
    int isolateThreshold = 400,
  }) async {
    final approxLines = oldText.length ~/ 40 + newText.length ~/ 40;
    if (approxLines < isolateThreshold) {
      return compute(oldText, newText, computeIntraline: computeIntraline);
    }
    return Isolate.run(
      () => compute(oldText, newText, computeIntraline: computeIntraline),
    );
  }

  /// Computes word/token-level intraline spans between [oldLine] and [newLine].
  static (List<DiffSpan> oldSpans, List<DiffSpan> newSpans)
      computeIntralineSpans(String oldLine, String newLine) {
    final oldTokens = _tokenizeWords(oldLine);
    final newTokens = _tokenizeWords(newLine);
    final ops = _diffSequences<String>(oldTokens, newTokens);

    final oldSpans = <DiffSpan>[];
    final newSpans = <DiffSpan>[];
    for (final op in ops) {
      if (op.$1 == DiffOpType.equal) {
        oldSpans.add(DiffSpan(text: op.$2, type: DiffOpType.equal));
        newSpans.add(DiffSpan(text: op.$2, type: DiffOpType.equal));
      } else if (op.$1 == DiffOpType.delete) {
        oldSpans.add(DiffSpan(text: op.$2, type: DiffOpType.delete));
      } else if (op.$1 == DiffOpType.insert) {
        newSpans.add(DiffSpan(text: op.$2, type: DiffOpType.insert));
      }
    }
    return (oldSpans, newSpans);
  }

  /// Formats a [DiffSummary] as a standard Unified Patch (`git diff`).
  static String toUnifiedPatch(
    DiffSummary summary, {
    String oldFileName = 'a/source',
    String newFileName = 'b/source',
  }) {
    final buffer = StringBuffer()
      ..writeln('--- $oldFileName')
      ..writeln('+++ $newFileName');
    for (final line in summary.lines) {
      buffer.writeln('${line.prefixSymbol}${line.content}');
    }
    return buffer.toString();
  }

  static void _attachIntralineHighlights(List<DiffLine> lines) {
    var i = 0;
    while (i < lines.length) {
      if (lines[i].type != DiffOpType.delete) {
        i++;
        continue;
      }
      final delStart = i;
      while (i < lines.length && lines[i].type == DiffOpType.delete) {
        i++;
      }
      final delCount = i - delStart;
      final insStart = i;
      while (i < lines.length && lines[i].type == DiffOpType.insert) {
        i++;
      }
      final insCount = i - insStart;
      final pairCount = delCount < insCount ? delCount : insCount;
      for (var k = 0; k < pairCount; k++) {
        final delLine = lines[delStart + k];
        final insLine = lines[insStart + k];
        final (oldSpans, newSpans) =
            computeIntralineSpans(delLine.content, insLine.content);
        lines[delStart + k] = DiffLine(
          type: delLine.type,
          content: delLine.content,
          oldLineNumber: delLine.oldLineNumber,
          intralineSpans: oldSpans,
        );
        lines[insStart + k] = DiffLine(
          type: insLine.type,
          content: insLine.content,
          newLineNumber: insLine.newLineNumber,
          intralineSpans: newSpans,
        );
      }
    }
  }

  static List<String> _splitLines(String text) {
    if (text.isEmpty) return const [];
    return text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
  }

  static List<String> _tokenizeWords(String line) {
    final matches = RegExp(r'(\s+|\w+|[^\s\w]+)').allMatches(line);
    return matches.map((m) => m.group(0)!).toList(growable: false);
  }

  static List<(DiffOpType, T)> _diffSequences<T>(List<T> a, List<T> b) {
    final n = a.length;
    final m = b.length;
    final dp = List<List<int>>.generate(
      n + 1,
      (_) => List<int>.filled(m + 1, 0),
    );
    for (var i = n - 1; i >= 0; i--) {
      for (var j = m - 1; j >= 0; j--) {
        if (a[i] == b[j]) {
          dp[i][j] = 1 + dp[i + 1][j + 1];
        } else {
          final down = dp[i + 1][j];
          final right = dp[i][j + 1];
          dp[i][j] = down >= right ? down : right;
        }
      }
    }

    final result = <(DiffOpType, T)>[];
    var i = 0;
    var j = 0;
    while (i < n && j < m) {
      if (a[i] == b[j]) {
        result.add((DiffOpType.equal, a[i]));
        i++;
        j++;
      } else if (dp[i + 1][j] >= dp[i][j + 1]) {
        result.add((DiffOpType.delete, a[i]));
        i++;
      } else {
        result.add((DiffOpType.insert, b[j]));
        j++;
      }
    }
    while (i < n) {
      result.add((DiffOpType.delete, a[i++]));
    }
    while (j < m) {
      result.add((DiffOpType.insert, b[j++]));
    }
    return result;
  }
}
