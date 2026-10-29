import 'package:flutter/material.dart';
import 'package:zero_diff/zero_diff.dart';

void main() => runApp(const ZeroDiffShowcaseApp());

/// Interactive code diff and 50,000-line ANSI log console showcase for
/// `zero_diff`.
class ZeroDiffShowcaseApp extends StatelessWidget {
  /// Creates a [ZeroDiffShowcaseApp].
  const ZeroDiffShowcaseApp({super.key});

  static const String _oldSource = '''
class MatchingEngine {
  final int maxDepth = 64;

  double computeFee(double notional) {
    final rate = 0.0025;
    return notional * rate;
  }

  bool validateOrder(double price, double qty) {
    return price > 0 && qty > 0;
  }
}''';

  static const String _newSource = '''
class MatchingEngine {
  final int maxDepth = 256;

  double computeFee(double notional, {bool isMaker = true}) {
    final rate = isMaker ? 0.0010 : 0.0020;
    return notional * rate;
  }

  bool validateOrder(double price, double qty) {
    return price > 0 && qty >= 0.001;
  }
}''';

  @override
  Widget build(BuildContext context) {
    final logs = List<String>.generate(50000, (i) {
      if (i % 4 == 0) {
        return '\x1B[32m[OK]\x1B[0m Committed batch #${100 + i} in 0.8ms';
      }
      if (i % 4 == 1) {
        return '\x1B[36m[TRACE]\x1B[0m Heartbeat signal ack from shard-${i % 8}';
      }
      if (i % 4 == 2) {
        return '\x1B[33m[WARN]\x1B[0m GC pause 2.1ms on isolate-worker-${i % 4}';
      }
      return '\x1B[31m[ERROR]\x1B[0m Frame budget spike detected on tick #$i';
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xFF080B12),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1524),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('zero_diff — 120Hz Diff & ANSI Log Engine', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text('Myers O(ND) • Word Intraline • 50,000 ANSI Logs', style: TextStyle(fontSize: 11, color: Color(0xFF00E676))),
            ],
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              flex: 5,
              child: ZeroDiffViewer(
                oldText: _oldSource,
                newText: _newSource,
                initialMode: DiffViewMode.unified,
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
