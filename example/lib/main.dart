import 'package:flutter/material.dart';
import 'package:zero_diff/zero_diff.dart';

void main() => runApp(const ZeroDiffShowcaseApp());

/// Interactive code diff and 50,000-line ANSI log console showcase for
/// `zero_diff`.
class ZeroDiffShowcaseApp extends StatelessWidget {
  /// Creates a [ZeroDiffShowcaseApp].
  const ZeroDiffShowcaseApp({super.key});

  static const String _oldSource = '''
class OrderEngine {
  double computeFee(double notional) {
    return notional * 0.0025;
  }
}''';

  static const String _newSource = '''
class OrderEngine {
  double computeFee(double notional, {bool isMaker = true}) {
    final rate = isMaker ? 0.0010 : 0.0020;
    return notional * rate;
  }
}''';

  @override
  Widget build(BuildContext context) {
    final logs = List<String>.generate(50000, (i) {
      if (i % 7 == 0) {
        return '\x1B[31m[ERROR]\x1B[0m Frame budget warning on worker #$i';
      }
      if (i % 3 == 0) {
        return '\x1B[32m[OK]\x1B[0m Committed transaction batch #$i in 0.8ms';
      }
      return '\x1B[36m[TRACE]\x1B[0m Heartbeat signal ack from shard-${i % 8}';
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xFF080B12),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1524),
          title: const Text('zero_diff — 120Hz Diff & ANSI Log Engine'),
        ),
        body: Column(
          children: [
            const Expanded(
              flex: 5,
              child: ZeroDiffViewer(
                oldText: _oldSource,
                newText: _newSource,
                initialMode: DiffViewMode.sideBySide,
              ),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Expanded(
              flex: 5,
              child: ZeroLogConsole(logs: logs),
            ),
          ],
        ),
      ),
    );
  }
}
