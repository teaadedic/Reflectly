import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen shows titles and images', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // Check for all home card titles
    expect(find.text('Journaling'), findsOneWidget);
    expect(find.text('Breathing Exercises'), findsOneWidget);
    expect(find.text('Mood Graphs'), findsOneWidget);
    expect(find.text('Quotes'), findsOneWidget);

    // Check for images (by type)
    expect(find.byType(Image), findsNWidgets(4));

    // Check for bottom navigation icons
    expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Check for the RichText title in the AppBar
    final richTexts = find.byType(RichText).evaluate().toList();
    bool found = false;
    for (final element in richTexts) {
      final richText = element.widget as RichText;
      final textSpan = richText.text as TextSpan;
      final fullText = textSpan.toPlainText();
      if (fullText.contains('Reflect.') && fullText.contains('Heal. Grow.')) {
        found = true;
        break;
      }
    }
    expect(
      found,
      isTrue,
      reason: 'AppBar title with "Reflect. Heal. Grow."',
    );
  });
}
