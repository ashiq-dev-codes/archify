// Smoke test for the app Archify scaffolded via `configure`/`generate auth`.
// Re-run `dart run archify generate <feature>` and wire it into lib/app.dart
// to try out template changes, then update this test to match.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/root.dart';

void main() {
  testWidgets('AppRoot renders the generated auth screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AppRoot());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
