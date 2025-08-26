import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movies/main.dart' as app;

void main() {
  testWidgets('add game via + icon, enter title, save', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap the add icon
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter a title in the text field labeled 'Game Title'
    await tester.enterText(find.widgetWithText(TextFormField, 'Game Title'), 'Zelda');

    // Tap the Save button
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify the new item appears on the list
    expect(find.text('Zelda'), findsOneWidget);
  });
}


