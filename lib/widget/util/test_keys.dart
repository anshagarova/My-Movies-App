import 'package:flutter/material.dart';

/// This is for the patrol integration tests so that you can for example fill values in TextFormField or click button
/// by key. Using unique prefix to prevent collision over same keys.
const _UNIQUE_PREFIX = 'test-keys';

class TestKeys {
  const TestKeys._();

  //Permission Notifier Dialog Keys
  static const INPUT_FIELD = Key('$_UNIQUE_PREFIX-input-field');
}
