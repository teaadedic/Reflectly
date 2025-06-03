import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/account_screen.dart';

void main() {
  testWidgets('AccountScreen shows app bar,edit button and icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AccountScreen()));
    await tester.pumpAndSettle();

    // Check for the AppBar title
    expect(find.text('Account'), findsOneWidget);

    // Check for Edit Profile button (by text)
    expect(find.text('Edit Profile'), findsOneWidget);

    // Optionally, check for the edit icon
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
