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

  patrolTest('Add game and rate it as good', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await addGame($, 'Zelda');
    final zeldaCard = findCardByTitle('Zelda');

    final goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    final badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await rate($, zeldaCard, 'Good');

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 1,
        badDelta: 0,
        goodBefore: goodBefore,
        badBefore: badBefore);
  });

  patrolTest('Add game and rate it as bad', ($) async {
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

    final goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    final badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: marioCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 0,
        badDelta: 1,
        goodBefore: goodBefore,
        badBefore: badBefore);
  });

  patrolTest('Update rating from bad to good', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('Astro Bot');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('Astro Bot').waitUntilVisible();

    final astrobotCard = find.ancestor(
      of: find.text('Astro Bot'),
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

  patrolTest('Add game and rename it', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await addGame($, 'The Last of Us');
    final tlouCard = findCardByTitle('The Last of Us');

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

    await rename($, tlouCard, 'The Last of Us: Part Two');

    final goodAfter = readCounter($, TestKeys.GOOD_COUNTER);
    final badAfter = readCounter($, TestKeys.BAD_COUNTER);

    expect(goodAfter, goodBefore + 1);
    expect(badAfter, badBefore);
  });

  patrolTest('Remove current rating', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('God of War');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('God of War').waitUntilVisible();

    final godofwarCard = find.ancestor(
      of: find.text('God of War'),
      matching: find.byType(Card),
    );

    var goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    var badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: godofwarCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 1,
        badDelta: 0,
        goodBefore: goodBefore,
        badBefore: badBefore);

    goodBefore = readCounter($, TestKeys.GOOD_COUNTER);
    badBefore = readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: godofwarCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: -1,
        badDelta: 0,
        goodBefore: goodBefore,
        badBefore: badBefore);
  });

  patrolTest('Filter by Good and Bad counters', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('GoodOne');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('GoodOne').waitUntilVisible();

    final goodOneCard = find.ancestor(
      of: find.text('GoodOne'),
      matching: find.byType(Card),
    );

    await $(find.descendant(
      of: goodOneCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();
    await $.pumpAndSettle();

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('BadOne');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('BadOne').waitUntilVisible();

    final badOneCard = find.ancestor(
      of: find.text('BadOne'),
      matching: find.byType(Card),
    );

    await $(find.descendant(
      of: badOneCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();
    await $.pumpAndSettle();

    await $(find.byKey(TestKeys.GOOD_COUNTER)).tap();
    await $.pumpAndSettle();
    await $('GoodOne').waitUntilVisible();
    expect(find.text('BadOne'), findsNothing);

    await $(find.byKey(TestKeys.BAD_COUNTER)).tap();
    await $.pumpAndSettle();
    await $('BadOne').waitUntilVisible();
    expect(find.text('GoodOne'), findsNothing);
  });


  patrolTest('Cannot add an identical title', ($) async {
    setup();
    await $.pumpWidgetAndSettle(AppWrapper(key: UniqueKey()));

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('The Withcer 3');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('The Withcer 3').waitUntilVisible();

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('The Withcer 3');
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