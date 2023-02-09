import 'package:flutter/material.dart';

import '../constant.dart';
import 'extended_translation.dart';

class DefaultExtendedTranslation extends ExtendedTranslation {
  @override
  Map<String, Map<String, String>> get keys => {
    'in_ID': {}
  };

  @override
  Map<String, Map<String, OnInitTextSpan>> get keysForTextSpan => {};
}