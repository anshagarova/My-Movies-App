import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:my_movies/widget/app_wrapper.dart';
import 'package:my_movies/widget/util/test_keys.dart';
import 'package:patrol/patrol.dart';

final getIt = GetIt.instance;

void main() {
  void setup() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<FilmManager>()) {
      getIt.registerSingleton<FilmManager>(FilmManager());
    }
  }

  patrolTest('add game and rate as good', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('Zelda');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('Zelda').waitUntilVisible();

    final zeldaCard = find.ancestor(
      of: find.text('Zelda'),
      matching: find.byType(Card),
    );

    await $(find.descendant(
      of: zeldaCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await $.pumpAndSettle();
    await $('Good Games: 1').waitUntilVisible();
  });

  patrolTest('add game and rate as bad', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('Mario');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('Mario').waitUntilVisible();

    final marioCard = find.ancestor(
      of: find.text('Mario'),
      matching: find.byType(Card),
    );

    await $(find.descendant(
      of: marioCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();

    await $.pumpAndSettle();
    await $('Bad Games: 1').waitUntilVisible();
  });
}
