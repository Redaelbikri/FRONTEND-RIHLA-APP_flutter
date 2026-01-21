import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihla2026/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RIHLA 2026 app builds without crashing', (WidgetTester tester) async {
    // Ignore asset loading errors during widget tests (Image.asset).
    final FlutterExceptionHandler? oldHandler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exceptionAsString();
      if (exception.contains('Unable to load asset')) return;
      oldHandler?.call(details);
    };

    await tester.pumpWidget(const RihlaApp());
    await tester.pump(); // first frame

    // App root should exist
    expect(find.byType(MaterialApp), findsOneWidget);

    // Splash content should appear (logo text)
    expect(find.text('RIHLA'), findsWidgets);

    // Let splash animations/timers run a bit
    await tester.pump(const Duration(milliseconds: 400));

    // App still alive
    expect(find.byType(Scaffold), findsWidgets);

    // Restore default handler
    FlutterError.onError = oldHandler;
  });
}
