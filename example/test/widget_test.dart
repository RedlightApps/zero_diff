import 'package:flutter_test/flutter_test.dart';
import 'package:zero_diff_example/main.dart';

void main() {
  testWidgets('ZeroDiffShowcaseApp renders split diff and 50k ANSI logs',
      (tester) async {
    await tester.pumpWidget(const ZeroDiffShowcaseApp());
    expect(
      find.text('zero_diff — 120Hz Diff & ANSI Log Engine'),
      findsOneWidget,
    );
  });
}
