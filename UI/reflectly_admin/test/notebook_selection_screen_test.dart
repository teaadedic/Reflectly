// dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflectly_admin/screens/notebook_selection_screen.dart';

void main() {
  setUp(() async {
    // Clear SharedPreferences before each test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Displays default notebook', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NotebookSelectionScreen()));
    await tester.pumpAndSettle();
    expect(find.text('My Journal'), findsOneWidget);
  });

  testWidgets('Add a new notebook', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotebookSelectionScreen()));
    await tester.pumpAndSettle();

    // Tap FAB to open dialog
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter notebook name and create
    await tester.enterText(find.byType(TextField), 'Work Notes');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create'));
    await tester.pumpAndSettle();

    // Verify new notebook appears
    expect(find.text('Work Notes'), findsOneWidget);
  });

  testWidgets('Enter delete mode and delete a notebook', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'notebook_titles': <String>['My Journal', 'Work Notes'],
    });

    await tester.pumpWidget(const MaterialApp(home: NotebookSelectionScreen()));
    await tester.pumpAndSettle();

    // Enter delete mode
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Select 'Work Notes' for deletion
    final workNotesCheckbox = find.descendant(
      of: find.ancestor(
        of: find.text('Work Notes'),
        matching: find.byType(ListTile),
      ),
      matching: find.byType(Checkbox),
    );
    await tester.tap(workNotesCheckbox);
    await tester.pump();

    // Tap delete icon
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete));
    await tester.pumpAndSettle();

    // Confirm deletion in dialog
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Verify 'Work Notes' is gone
    expect(find.text('Work Notes'), findsNothing);
    expect(find.text('My Journal'), findsOneWidget);
  });

  testWidgets('Cancel delete mode', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotebookSelectionScreen()));
    await tester.pumpAndSettle();

    // Enter delete mode
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Cancel delete mode
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();

    // FAB should be visible again
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Open and cancel add notebook dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: NotebookSelectionScreen()));
    await tester.pumpAndSettle();

    // Open dialog
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Cancel dialog
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    // Dialog should be closed
    expect(find.byType(AlertDialog), findsNothing);
  });
}
