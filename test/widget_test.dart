// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list/main.dart';

void main() {
  testWidgets('Add a task to the to-do list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ToDoApp());

    // Verify that the initial state has no tasks.
    expect(find.text('Add a new task'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    // Enter a new task into the text field.
    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the new task has been added to the list.
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });
}
