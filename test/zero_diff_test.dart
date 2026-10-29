import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zero_diff/zero_diff.dart';

void main() {
  group('MyersDiffEngine & AnsiLogParser tests', () {
    test('computes line and intraline word diffs and exports Unified Patch',
        () async {
      const oldCode = 'final count = 1;\nprint("Hello world");';
      const newCode = 'final count = 2;\nprint("Hello Flutter");\nreturn count;';

      final summary = await MyersDiffEngine.computeAsync(
        oldCode,
        newCode,
        isolateThreshold: 1,
      );
      expect(summary.addedCount, 3);
      expect(summary.deletedCount, 2);

      final firstDelete = summary.lines.first;
      expect(firstDelete.type, DiffOpType.delete);
      expect(firstDelete.intralineSpans, isNotEmpty);

      final patch = MyersDiffEngine.toUnifiedPatch(summary);
      expect(patch, contains('--- a/source'));
      expect(patch, contains('+return count;'));
    });

    test('parses and strips ANSI color escape codes accurately', () {
      const raw = '\x1B[32m[PASS]\x1B[0m Build succeeded in 120ms';
      final segments = AnsiLogParser.parse(raw);
      expect(segments.first.text, '[PASS]');
      expect(segments.first.color, const Color(0xFF00E676));
      expect(
        AnsiLogParser.stripAnsi(raw),
        '[PASS] Build succeeded in 120ms',
      );
    });
  });

  group('ZeroDiffViewer & ZeroLogConsole widget tests', () {
    testWidgets('toggles Unified and Side-by-Side modes and filters ANSI logs',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ZeroDiffViewer(
                    oldText: 'int a = 10;',
                    newText: 'int a = 20;',
                  ),
                ),
                Expanded(
                  child: ZeroLogConsole(
                    logs: [
                      '\x1B[32m[INFO]\x1B[0m Connected to node-01',
                      '\x1B[31m[ERR]\x1B[0m Timeout on socket',
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('+1'), findsOneWidget);
      expect(find.text('-1'), findsOneWidget);

      await tester.tap(find.text(ZeroDiffDict.sideBySideModeLabel));
      await tester.pump();
      expect(find.text(ZeroDiffDict.unifiedModeLabel), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'timeout');
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });
}
