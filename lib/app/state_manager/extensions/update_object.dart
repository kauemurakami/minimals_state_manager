import 'package:flutter/foundation.dart';

extension UpdateExtension<T> on ValueNotifier<T> {
  void update(void Function(T) updateCallback) {
    T newValue = value;
    updateCallback(newValue);
    value = newValue;
  }
}
