import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/screens/breathing_exercises_screen.dart';

void main() {
  testWidgets('BreathingExercisesScreen shows main exercise titles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BreathingExercisesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Equal Breathing'), findsOneWidget);
    expect(find.text('Box Breathing'), findsOneWidget);
    expect(find.text('Relaxing Breath'), findsOneWidget);
  });

  testWidgets('BreathingExercisesScreen shows at least one Start Now button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BreathingExercisesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start Now'), findsWidgets);
  });

  testWidgets('BreathingExercisesScreen shows at least one pattern', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BreathingExercisesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('4-0-4-0'), findsOneWidget);
  });
}
