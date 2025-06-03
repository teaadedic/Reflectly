import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/chat_screen.dart';

void main() {
  testWidgets('ChatScreen shows header, text field, and send button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatScreen()));
    await tester.pumpAndSettle();

    // Check for header title
    expect(find.text('Reflectly Chatbot'), findsOneWidget);

    // Check for back button
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Check for bot avatar icon
    expect(find.byIcon(Icons.smart_toy), findsWidgets);

   
    // Check for text field
    expect(find.byType(TextField), findsOneWidget);

    // Check for send button
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}