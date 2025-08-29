import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:my_movies/widget/app_wrapper.dart';
import 'package:my_movies/widget/util/test_keys.dart';
import 'package:patrol/patrol.dart';
import 'package:flutter/widgets.dart' as widgets;

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

    final goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    final badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: zeldaCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await _expectCounterDelta($,
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

    final goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    final badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: marioCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();

    await _expectCounterDelta($,
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

    var goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    var badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: astrobotCard,
      matching: find.widgetWithText(ElevatedButton, 'Bad'),
    )).tap();

    await _expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 0,
        badDelta: 1,
        goodBefore: goodBefore,
        badBefore: badBefore);

    goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: astrobotCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await _expectCounterDelta($,
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

    await $(find.byIcon(Icons.add)).tap();
    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('The Last of Us');
    await $('Save').tap();
    await $.pumpAndSettle();
    await $('The Last of Us').waitUntilVisible();

    final tlouCard = find.ancestor(
      of: find.text('The Last of Us'),
      matching: find.byType(Card),
    );

    await $(find.descendant(
      of: tlouCard,
      matching: find.byType(GestureDetector),
    )).tap();

    await $.pumpAndSettle();
    await $(TestKeys.INPUT_FIELD).enterText('The Last of Us: Part Two');
    await $('Update').tap();
    await $.pumpAndSettle();
    await $('The Last of Us: Part Two').waitUntilVisible();
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

    var goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    var badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: godofwarCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await _expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: 1,
        badDelta: 0,
        goodBefore: goodBefore,
        badBefore: badBefore);

    goodBefore = _readCounter($, TestKeys.GOOD_COUNTER);
    badBefore = _readCounter($, TestKeys.BAD_COUNTER);

    await $(find.descendant(
      of: godofwarCard,
      matching: find.widgetWithText(ElevatedButton, 'Good'),
    )).tap();

    await _expectCounterDelta($,
        goodKey: TestKeys.GOOD_COUNTER,
        badKey: TestKeys.BAD_COUNTER,
        goodDelta: -1,
        badDelta: 0,
        goodBefore: goodBefore,
        badBefore: badBefore);
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

int _readCounter(dynamic $, Key key) {
  final element = $(find.byKey(key)).evaluate().single.widget as widgets.Text;
  final text = element.data ?? '';
  final numberMatch = RegExp(r'\b(\d+)\b').firstMatch(text);
  return int.parse(numberMatch!.group(1)!);
}

Future<void> _expectCounterDelta(
  dynamic $, {
  required Key goodKey,
  required Key badKey,
  required int goodDelta,
  required int badDelta,
  required int goodBefore,
  required int badBefore,
}) async {
  await $.pumpAndSettle();
  final goodAfter = _readCounter($, goodKey);
  final badAfter = _readCounter($, badKey);
  expect(goodAfter, goodBefore + goodDelta);
  expect(badAfter, badBefore + badDelta);
}
