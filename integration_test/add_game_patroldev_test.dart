import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movies/main.dart' as app;
import 'package:my_movies/widget/util/test_keys.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('add game flow (Patrol developing)', ($) async {
    app.main();
    await $.pumpAndSettle();

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();

    await $(TestKeys.INPUT_FIELD).enterText('Zelda');
    await $('Save').tap();
    await $.pumpAndSettle();

    await $('Zelda').waitUntilVisible();
  });
}
