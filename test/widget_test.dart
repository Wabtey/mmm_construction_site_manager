// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mmm_construction_site_manager/start_screen.dart'
    as start_screen;

void main() {
  testWidgets("StartScreen's login button", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: start_screen.StartScreenAnimation(),
    ));

    // animation completed
    await tester.pumpAndSettle();

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // TOTEST: verify that we changed screen
    expect(find.byType(Image), findsOneWidget);

    // 'Go back' button
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull);
  });
}
