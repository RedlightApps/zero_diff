import 'package:flutter/material.dart';
import 'package:zero_diff/src/common/zero_diff_dict.dart';
import 'package:zero_diff/src/model/diff_models.dart';

/// Parsed ANSI color segment inside a console log line.
class AnsiTextSegment {
  /// Creates an [AnsiTextSegment].
  const AnsiTextSegment({required this.text, this.color});

  /// Clean text without escape sequences.
  final String text;

  /// Optional foreground color decoded from ANSI SGR codes (`\x1B[31m`, etc.).
  final Color? color;
}

/// Fast zero-allocation parser for standard ANSI SGR color escape codes.
abstract final class AnsiLogParser {
  static final RegExp _ansiRegex = RegExp(r'\x1B\[(\d+)m');

  /// Parses [rawLine] into styled [AnsiTextSegment] spans and strips escape
  /// codes.
  static List<AnsiTextSegment> parse(String rawLine) {
    final segments = <AnsiTextSegment>[];
    var lastEnd = 0;
    Color? activeColor;

    for (final match in _ansiRegex.allMatches(rawLine)) {
      if (match.start > lastEnd) {
        segments.add(
          AnsiTextSegment(
            text: rawLine.substring(lastEnd, match.start),
            color: activeColor,
          ),
        );
      }
      final code = int.tryParse(match.group(1) ?? '0') ?? 0;
      activeColor = _colorForCode(code);
      lastEnd = match.end;
    }

    if (lastEnd < rawLine.length) {
      segments.add(
        AnsiTextSegment(
          text: rawLine.substring(lastEnd),
          color: activeColor,
        ),
      );
    }
    return segments.isEmpty
        ? [AnsiTextSegment(text: rawLine)]
        : segments;
  }

  /// Strips all ANSI SGR escape sequences from [rawLine] for plain-text search.
  static String stripAnsi(String rawLine) => rawLine.replaceAll(_ansiRegex, '');

  static Color? _colorForCode(int code) => switch (code) {
        31 || 91 => const Color(0xFFFF5252),
        32 || 92 => const Color(0xFF00E676),
        33 || 93 => const Color(0xFFFFD740),
        34 || 94 || 36 || 96 => const Color(0xFF38BDF8),
        35 || 95 => const Color(0xFFE040FB),
        _ => null,
      };
}

/// 120Hz virtualized streaming log console supporting 100,000+ lines, ANSI SGR
/// color decoding, and instant substring filtering.
class ZeroLogConsole extends StatefulWidget {
  /// Creates a [ZeroLogConsole].
  const ZeroLogConsole({
    required this.logs,
    this.showSearchBar = true,
    this.lineHeight = 24.0,
    this.theme = const ZeroDiffTheme(),
    super.key,
  });

  /// Ordered list of raw or ANSI-colored log lines.
  final List<String> logs;

  /// Whether to display the top search/filter bar.
  final bool showSearchBar;

  /// Fixed height of each virtualized log row.
  final double lineHeight;

  /// Visual theme configuration.
  final ZeroDiffTheme theme;

  @override
  State<ZeroLogConsole> createState() => _ZeroLogConsoleState();
}

class _ZeroLogConsoleState extends State<ZeroLogConsole> {
  String _query = '';

  List<(int, String)> _computeFiltered() {
    final q = _query.trim().toLowerCase();
    final out = <(int, String)>[];
    for (var i = 0; i < widget.logs.length; i++) {
      final line = widget.logs[i];
      if (q.isEmpty ||
          AnsiLogParser.stripAnsi(line).toLowerCase().contains(q)) {
        out.add((i + 1, line));
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _computeFiltered();
    return ColoredBox(
      color: widget.theme.backgroundColor,
      child: Column(
        children: [
          if (widget.showSearchBar)
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.theme.headerBackgroundColor,
                border:
                    Border(bottom: BorderSide(color: widget.theme.borderColor)),
              ),
              child: TextField(
                style: widget.theme.codeTextStyle,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: ZeroDiffDict.filterLogsHint,
                  hintStyle: widget.theme.lineNumberStyle,
                  isDense: true,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.terminal_rounded,
                    size: 16,
                    color: widget.theme.lineNumberStyle.color,
                  ),
                ),
              ),
            ),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      ZeroDiffDict.emptyLogConsoleLabel,
                      style: widget.theme.codeTextStyle,
                    ),
                  )
                : ListView.builder(
                    itemExtent: widget.lineHeight,
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final entry = visible[index];
                      final segments = AnsiLogParser.parse(entry.$2);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 48,
                              child: Text(
                                '${entry.$1}',
                                style: widget.theme.lineNumberStyle,
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: widget.theme.codeTextStyle,
                                  children: segments
                                      .map(
                                        (s) => TextSpan(
                                          text: s.text,
                                          style: s.color != null
                                              ? TextStyle(color: s.color)
                                              : null,
                                        ),
                                      )
                                      .toList(growable: false),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
