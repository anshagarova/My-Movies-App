import 'package:flutter/material.dart';
import 'helpers.dart';
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

// ---------------- Add & rate title tests ----------------

  for (final rating in ['Good', 'Bad']) {
    patrolTest('Add game and rate it as $rating', ($) async {
      setup();
      await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

      final title = uniqueTitle('Test Game');
      await addGame($, title);
      final gameCard = findCardByTitle(title);

      final goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
      final badBefore = readCounter($, TestKeys.BAD_COUNTER);

      await rate($, gameCard, rating);

      final expectedGoodDelta = rating == 'Good' ? 1 : 0;
      final expectedBadDelta = rating == 'Bad' ? 1 : 0;

      await expectCounterDelta($,
          goodKey: TestKeys.GOOD_COUNTER,
          badKey: TestKeys.BAD_COUNTER,
          goodDelta: expectedGoodDelta,
          badDelta: expectedBadDelta,
          goodBefore: goodBefore,
          badBefore: badBefore);
    });
  }

  patrolTest('Update rating from bad to good', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    final title = uniqueTitle('Astro Bot');
    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText(title);
    await $('Save').tap();
    await $.pumpAndSettle();
    await $(title).waitUntilVisible();

    final astrobotCard = find.ancestor(
      of: find.text(title),
      matching: find.byType(Card),
    );

    var goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    var badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: astrobotCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 0,
        badDelta: 1,
        goodBefore: goodBefore,
        badBefore: badBefore);

    goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: astrobotCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 1,
        badDelta: -1,
        goodBefore: goodBefore,
        badBefore: badBefore);
  });

  for (final rating in ['Good', 'Bad']) {
    patrolTest('Remove current $rating rating', ($) async {
      setup();
      await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

      final title = uniqueTitle('Test Game');
      await addGame($, title);
      final gameCard = findCardByTitle(title);

      var goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
      var badBefore = readCounter($, TestKeys.BAD_COUNTER);

      await rate($, gameCard, rating);

      final expectedGoodDelta = rating == 'Good' ? 1 : 0;
      final expectedBadDelta = rating == 'Bad' ? 1 : 0;

      await expectCounterDelta($,
          goodKey: TestKeys.GOOD_COUNTER,
          badKey: TestKeys.BAD_COUNTER,
          goodDelta: expectedGoodDelta,
          badDelta: expectedBadDelta,
          goodBefore: goodBefore,
          badBefore: badBefore);

      goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
      badBefore = readCounter($, TestKeys.BAD_COUNTER);

      await rate($, gameCard, rating);

      await expectCounterDelta($,
          goodKey: TestKeys.GOOD_COUNTER,
          badKey: TestKeys.BAD_COUNTER,
          goodDelta: -expectedGoodDelta,
          badDelta: -expectedBadDelta,
          goodBefore: goodBefore,
          badBefore: badBefore);
    });
  }

  // ---------------- Filtering & counters ----------------

  for (final rating in ['Good', 'Bad']) {
    patrolTest('Filter by $rating counter', ($) async {
      setup();
      await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

      final targetTitle = uniqueTitle('${rating}Game');
      await addGame($, targetTitle);
      final targetCard = findCardByTitle(targetTitle);
      await rate($, targetCard, rating);
      await $.pumpAndSettle();

      final oppositeRating = rating == 'Good' ? 'Bad' : 'Good';
      final oppositeTitle = uniqueTitle('${oppositeRating}Game');
      await addGame($, oppositeTitle);
      final oppositeCard = findCardByTitle(oppositeTitle);
      await rate($, oppositeCard, oppositeRating);
      await $.pumpAndSettle();

      final counterKey = rating == 'Good' ? TestKeys.GOOD_COUNTER : TestKeys.BAD_COUNTER;
      await $(find.byKey(counterKey)).tap();
      await $.pumpAndSettle();
      
      await $(targetTitle).waitUntilVisible();
      expect(find.text(oppositeTitle), findsNothing);
    });
  }

// ---------------- Title management tests ----------------

 patrolTest('Add game and rename it', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    final title = uniqueTitle('The Last of Us');
    await addGame($, title);
    final tlouCard = findCardByTitle(title);

    final goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    final badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await rate($, tlouCard, 'Good');

    await expectCounterDelta($,
      goodKey: TestKeys.GOOD_COUNTER,
      badKey: TestKeys.BAD_COUNTER,
      goodDelta: 1,
      badDelta: 0,
      goodBefore: goodBefore,
      badBefore: badBefore,
    );

    final newTitle = uniqueTitle('The Last of Us: Part Two');
    await rename($, tlouCard, newTitle);

    final goodAfter = readCounter($, TestKeys.GOOD_COUNTER);
    final badAfter = readCounter($, TestKeys.BAD_COUNTER);

    expect(goodAfter, goodBefore + 1);
    expect(badAfter, badBefore);
  });

  patrolTest('Cannot add an identical title', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    final title = uniqueTitle('The Witcher 3');
    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText(title);
    await $('Save').tap();
    await $.pumpAndSettle();
    await $(title).waitUntilVisible();

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText(title);
    await $('Save').tap();
    await $.pumpAndSettle();

    await $('This title already exists').waitUntilVisible();
  });

  patrolTest('Cannot save empty game title', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();

    await $(TestKeys.INPUT_FIELD).waitUntilVisible();

    await $('Save').tap();
    await $.pumpAndSettle();

    await $('Please enter a title').waitUntilVisible();
  });

}