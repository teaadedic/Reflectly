import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/journal_screen.dart';

void main() {
  testWidgets('JournalScreen shows text field, done and clear buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: JournalScreen(notebookTitle: 'My Journal')),
    );
    await tester.pumpAndSettle();

    // Check for the text field
    expect(find.byType(TextField), findsOneWidget);

    // Check for the "Done" button (FloatingActionButton.extended)
    expect(find.widgetWithText(FloatingActionButton, 'Done'), findsOneWidget);

    // Check for the clear (delete) button in the AppBar
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    // Check that the text field accepts input
    await tester.enterText(find.byType(TextField), 'Hello Journal');
    expect(find.text('Hello Journal'), findsOneWidget);
  });
}
