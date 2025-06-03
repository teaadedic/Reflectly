import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/breathing_player_screen.dart';

void main() {
  testWidgets('BreathingPlayerScreen displays content', (
    WidgetTester tester,
  ) async {
    // Provide test data
    await tester.pumpWidget(
      MaterialApp(
        home: BreathingPlayerScreen(
          title: 'Relax',
          caption: 'Calm your mind',
          image: 'assets/images/breathing.png',
          duration: '3 min',
          pattern: '4-4-4-4',
          color: Colors.blue,
          audio: null, // No audio for widget test
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check for title, pattern, and description
    expect(find.text('Relax'), findsOneWidget);
    expect(find.textContaining('Pattern: 4-4-4-4'), findsOneWidget);
    expect(
      find.textContaining('Inhale through your nose for 4 seconds'),
      findsOneWidget,
    );

    // Check for play button (should be play icon initially)
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);

    // Check for replay button
    expect(find.byIcon(Icons.replay), findsOneWidget);

    // Check for image widget
    expect(find.byType(Image), findsOneWidget);
  });
}
