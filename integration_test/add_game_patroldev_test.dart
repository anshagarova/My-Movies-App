import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:my_movies/main.dart' as app;

void main() {
  patrolTest('add game flow (Patrol developing)', ($) async {
    app.main();
    await $.pumpAndSettle();

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();

    await $('Game Title').enterText('Zelda');
    await $('Save').tap();
    await $.pumpAndSettle();

    await $('Zelda').waitUntilVisible();
  });
}


