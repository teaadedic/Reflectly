import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectly_admin/main.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .window
        .physicalSizeTestValue = const Size(1200, 2000);
    TestWidgetsFlutterBinding.ensureInitialized()
        .window
        .devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.ensureInitialized().window
        .clearPhysicalSizeTestValue();
    TestWidgetsFlutterBinding.ensureInitialized().window
        .clearDevicePixelRatioTestValue();
  });

  testWidgets('LoginPage shows username and password fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have account? "), findsOneWidget);
    expect(find.text("Sign up"), findsOneWidget);
  });

  testWidgets('SignUpPage shows all input fields and register button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    // Only check for the Register button, not both texts
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    expect(find.text('Already have account? '), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('LoginPage navigates to SignUpPage on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    // Only check for the Register button and the subtitle
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    expect(find.text('Create your new account'), findsOneWidget);
  });
}
