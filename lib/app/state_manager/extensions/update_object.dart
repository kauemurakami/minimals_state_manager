import 'package:flutter/foundation.dart';

extension ValueNotifierExtension<T> on ValueNotifier<T> {
  T update(T Function(T val) updater) {
    final updatedValue = updater(value);
    value = updatedValue;
    return updatedValue;
  }
}
