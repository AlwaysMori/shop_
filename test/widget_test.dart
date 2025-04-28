// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bank_lampung/auth/register_page.dart';

void main() {
  testWidgets('RegisterPage renders correctly', (WidgetTester tester) async {
    // Build the RegisterPage widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: RegisterPage()));

    // Verify that all form fields and the register button are present.
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Employee Name'), findsOneWidget);
    expect(find.text('Position'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Interact with the form fields.
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'John Doe');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cashier').last);
    await tester.pump();

    // Submit the form.
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify that a success message is shown.
    expect(find.text('Employee registered successfully!'), findsOneWidget);
  });
}
