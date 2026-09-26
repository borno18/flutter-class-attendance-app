import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_app/main.dart';

void main() {
  testWidgets('Test Add Student and Analytics flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.pumpAndSettle();

    // 1. Welcome -> Classes
    await tester.tap(find.text('Go to Classes'));
    await tester.pumpAndSettle();

    // 2. Open Class 10-A
    await tester.tap(find.text('Class 10-A'));
    await tester.pumpAndSettle();

    // 3. Test Add Student
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add Student'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Charlie');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify Charlie is now in list
    expect(find.text('Charlie'), findsOneWidget);

    // 4. Test Calling Names
    await tester.tap(find.text('Start Calling Names'));
    await tester.pumpAndSettle();

    expect(find.text('Calling: John'), findsOneWidget);
    // Mark John Present
    await tester.tap(find.text('Present'));
    await tester.pumpAndSettle();

    expect(find.text('Calling: Alice'), findsOneWidget);
    // Mark Alice Absent
    await tester.tap(find.text('Absent'));
    await tester.pumpAndSettle();

    // Exit calling
    Navigator.pop(tester.element(find.text('Calling: Bob')));
    await tester.pumpAndSettle();

    // 5. Test Analytics
    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();

    expect(find.text('Class 10-A Analytics'), findsOneWidget);
    expect(find.text('Present Students (1):'), findsOneWidget);
    expect(find.text('• John'), findsOneWidget);
    expect(find.text('Absent Students (1):'), findsOneWidget);
    expect(find.text('• Alice'), findsOneWidget);
  });
}
