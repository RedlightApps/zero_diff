import 'package:flutter/material.dart';
import 'package:zero_diff/src/common/zero_diff_dict.dart';
import 'package:zero_diff/src/engine/myers_diff_engine.dart';
import 'package:zero_diff/src/model/diff_models.dart';

/// 120Hz virtualized code and text comparison widget supporting both
/// [DiffViewMode.unified] and synchronized [DiffViewMode.sideBySide] split
/// views with word-level intraline highlights.
class ZeroDiffViewer extends StatefulWidget {
  /// Creates a [ZeroDiffViewer].
  const ZeroDiffViewer({
    required this.oldText,
    required this.newText,
    this.initialMode = DiffViewMode.unified,
    this.showToolbar = true,
    this.lineHeight = 26.0,
    this.theme = const ZeroDiffTheme(),
    super.key,
  });

  /// Original text or source code.
  final String oldText;
  /// Updated text or source code.
  final String newText;
  /// Initial presentation mode (`unified` or `sideBySide`).
  final DiffViewMode initialMode;
  /// Whether to render the top summary bar with `+added / -deleted` badges.
  final bool showToolbar;
  /// Fixed height of each diff row in logical pixels.
  final double lineHeight;
  /// Visual theme configuration.
  final ZeroDiffTheme theme;

  @override
  State<ZeroDiffViewer> createState() => _ZeroDiffViewerState();
}

class _ZeroDiffViewerState extends State<ZeroDiffViewer> {
  late DiffViewMode _mode;
  late DiffSummary _summary;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _summary = MyersDiffEngine.compute(widget.oldText, widget.newText);
  }

  @override
  void didUpdateWidget(covariant ZeroDiffViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMode != widget.initialMode) {
      _mode = widget.initialMode;
    }
    if (oldWidget.oldText != widget.oldText ||
        oldWidget.newText != widget.newText) {
      _summary = MyersDiffEngine.compute(widget.oldText, widget.newText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pairs = _mode == DiffViewMode.sideBySide
        ? _buildSideBySidePairs(_summary.lines)
        : const <(DiffLine?, DiffLine?)>[];

    return ColoredBox(
      color: widget.theme.backgroundColor,
      child: Column(
        children: [
          if (widget.showToolbar) _buildToolbar(),
          Expanded(
            child: _summary.lines.isEmpty
                ? Center(
                    child: Text(
                      ZeroDiffDict.noDifferencesLabel,
                      style: widget.theme.codeTextStyle,
                    ),
                  )
                : _mode == DiffViewMode.unified
                    ? ListView.builder(
                        itemExtent: widget.lineHeight,
                        itemCount: _summary.lines.length,
                        itemBuilder: (context, i) =>
                            _buildUnifiedRow(_summary.lines[i]),
                      )
                    : ListView.builder(
                        itemExtent: widget.lineHeight,
                        itemCount: pairs.length,
                        itemBuilder: (context, i) =>
                            _buildSplitRow(pairs[i].$1, pairs[i].$2),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: widget.theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: widget.theme.borderColor)),
      ),
      child: Row(
        children: [
          Text(
            '+${_summary.addedCount}',
            style: widget.theme.codeTextStyle.copyWith(
              color: widget.theme.addedTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '-${_summary.deletedCount}',
            style: widget.theme.codeTextStyle.copyWith(
              color: widget.theme.deletedTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => setState(() {
              _mode = _mode == DiffViewMode.unified
                  ? DiffViewMode.sideBySide
                  : DiffViewMode.unified;
            }),
            child: Text(
              _mode == DiffViewMode.unified
                  ? ZeroDiffDict.sideBySideModeLabel
                  : ZeroDiffDict.unifiedModeLabel,
              style: widget.theme.codeTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Color _rowBg(DiffOpType type) => switch (type) {
        DiffOpType.equal => widget.theme.backgroundColor,
        DiffOpType.delete => widget.theme.deletedLineColor,
        DiffOpType.insert => widget.theme.addedLineColor,
      };

  Widget _buildUnifiedRow(DiffLine line) {
    return Container(
      color: _rowBg(line.type),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(width: 36, child: Text('${line.oldLineNumber ?? ''}', style: widget.theme.lineNumberStyle)),
          SizedBox(width: 36, child: Text('${line.newLineNumber ?? ''}', style: widget.theme.lineNumberStyle)),
          SizedBox(width: 16, child: Text(line.prefixSymbol, style: widget.theme.codeTextStyle)),
          Expanded(child: _buildRichLineText(line)),
        ],
      ),
    );
  }

  Widget _buildSplitRow(DiffLine? left, DiffLine? right) {
    return Row(
      children: [
        Expanded(child: _buildHalfCell(left, isLeft: true)),
        Container(width: 1, color: widget.theme.borderColor),
        Expanded(child: _buildHalfCell(right, isLeft: false)),
      ],
    );
  }

  Widget _buildHalfCell(DiffLine? line, {required bool isLeft}) {
    if (line == null) return ColoredBox(color: widget.theme.backgroundColor);
    final lineNo = isLeft ? line.oldLineNumber : line.newLineNumber;
    return Container(
      color: _rowBg(line.type),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SizedBox(width: 34, child: Text('${lineNo ?? ''}', style: widget.theme.lineNumberStyle)),
          Expanded(child: _buildRichLineText(line)),
        ],
      ),
    );
  }

  Widget _buildRichLineText(DiffLine line) {
    if (line.intralineSpans.isEmpty) {
      return Text(line.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: widget.theme.codeTextStyle);
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: widget.theme.codeTextStyle,
        children: line.intralineSpans.map((span) {
          final bg = switch (span.type) {
            DiffOpType.equal => null,
            DiffOpType.delete => widget.theme.deletedWordHighlight,
            DiffOpType.insert => widget.theme.addedWordHighlight,
          };
          return TextSpan(text: span.text, style: bg != null ? TextStyle(backgroundColor: bg) : null);
        }).toList(growable: false),
      ),
    );
  }

  List<(DiffLine?, DiffLine?)> _buildSideBySidePairs(List<DiffLine> lines) {
    final pairs = <(DiffLine?, DiffLine?)>[];
    var i = 0;
    while (i < lines.length) {
      if (lines[i].type == DiffOpType.equal) {
        pairs.add((lines[i], lines[i]));
        i++;
      } else {
        final dels = <DiffLine>[];
        while (i < lines.length && lines[i].type == DiffOpType.delete) {
          dels.add(lines[i++]);
        }
        final ins = <DiffLine>[];
        while (i < lines.length && lines[i].type == DiffOpType.insert) {
          ins.add(lines[i++]);
        }
        final count = dels.length > ins.length ? dels.length : ins.length;
        for (var k = 0; k < count; k++) {
          pairs.add((k < dels.length ? dels[k] : null, k < ins.length ? ins[k] : null));
        }
      }
    }
    return pairs;
  }
}
