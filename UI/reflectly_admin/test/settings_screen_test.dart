import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen shows all main buttons and titles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    // Check for main title
    expect(find.text('Settings'), findsOneWidget);

    // Check for all settings card titles
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // Check for notification and reminder switches
    expect(find.byType(Switch), findsNWidgets(2));

    // Check for bottom navigation icons
    expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Check for chat icon button in AppBar
    expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
  });
}
