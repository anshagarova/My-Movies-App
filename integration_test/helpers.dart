import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movies/widget/util/test_keys.dart';

int readCounter(dynamic $, Key key) {
  final element = $(find.byKey(key)).evaluate().single.widget as widgets.Text;
  final text = element.data ?? '';
  final numberMatch = RegExp(r'\b(\d+)\b').firstMatch(text);
  return int.parse(numberMatch!.group(1)!);
}

Future<void> expectCounterDelta(
  dynamic $, {
  required Key goodKey,
  required Key badKey,
  required int goodDelta,
  required int badDelta,
  required int goodBefore,
  required int badBefore,
}) async {
  await $.pumpAndSettle();
  final goodAfter = readCounter($, goodKey);
  final badAfter = readCounter($, badKey);
  expect(goodAfter, goodBefore + goodDelta);
  expect(badAfter, badBefore + badDelta);
}

Future<void> addGame(dynamic $, String title) async {
  await $(find.byIcon(Icons.add)).tap();
  await $.pumpAndSettle();
  await $(TestKeys.INPUT_FIELD).enterText(title);
  await $('Save').tap();
  await $.pumpAndSettle();
  await $(title).waitUntilVisible();
}

Finder findCardByTitle(String title) {
  return find.ancestor(of: find.text(title), matching: find.byType(Card));
}

Future<void> rate(dynamic $, Finder card, String label) async {
  await $(find.descendant(
    of: card,
    matching: find.widgetWithText(ElevatedButton, label),
  )).tap();
  await $.pumpAndSettle();
}

Future<void> rename(dynamic $, Finder card, String newTitle) async {
  await $(find.descendant(
    of: card,
    matching: find.byType(GestureDetector),
  )).tap();
  await $.pumpAndSettle();
  await $(TestKeys.INPUT_FIELD).enterText(newTitle);
  await $('Update').tap();
  await $.pumpAndSettle();
  await $(newTitle).waitUntilVisible();
}

Future<void> tapCounter(dynamic $, Key counterKey) async {
  await $(find.byKey(counterKey)).tap();
  await $.pumpAndSettle();
}

Future<void> expectNoCounterChange(dynamic $, {required int goodBefore, required int badBefore}) async {
  await expectCounterDelta($,
    goodKey: TestKeys.GOOD_COUNTER,
    badKey: TestKeys.BAD_COUNTER,
    goodDelta: 0,
    badDelta: 0,
    goodBefore: goodBefore,
    badBefore: badBefore,
  );
}


