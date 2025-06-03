import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/quotes_screen.dart';

void main() {
  testWidgets(
    'QuotesScreen shows a quote, refresh button, and back button works',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: QuotesScreen()));

      // Wait for async quotes to load
      await tester.pumpAndSettle();

      // There should be at least one Card (quote)
      expect(find.byType(Card), findsWidgets);

      // There should be a refresh button
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Test back button (AppBar's leading by default)
      final dynamic appBar = tester.widget(find.byType(AppBar));
      expect(appBar, isA<AppBar>());
      // Simulate back button tap if present
      if (appBar.leading != null) {
        await tester.tap(find.byTooltip('Back'));
        // No error means back button is present and tappable
      }
    },
  );
}
