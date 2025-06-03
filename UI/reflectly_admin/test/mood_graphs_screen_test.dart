import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/mood_graphs_screen.dart';

void main() {
  testWidgets('MoodGraphsScreen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MoodGraphsScreen()));
    await tester.pump(const Duration(milliseconds: 100)); // Give time for build

    // Minimal: just check that the widget tree contains a Scaffold
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
