import 'package:flutter/foundation.dart';

extension StringExtension on String {
  /// Returns a `ValueNotifier<String>` with [this] `String` as initial value.
  ValueNotifier<String> get minx => ValueNotifier<String>(this);
}

extension IntExtension on int {
  /// Returns a `ValueNotifier<int>` with [this] `int` as initial value.
  ValueNotifier<int> get minx => ValueNotifier<int>(this);
}

extension DoubleExtension on double {
  /// Returns a `ValueNotifier<double>` with [this] `double` as initial value.
  ValueNotifier<double> get minx => ValueNotifier<double>(this);
}

extension BoolExtension on bool {
  /// Returns a `ValueNotifier<bool>` with [this] `bool` as initial value.
  ValueNotifier<bool> get minx => ValueNotifier<bool>(this);
}

extension RxT<T> on T {
  /// Returns a `ValueNotifier<T>` instance with [this] `T` as initial value.
  ValueNotifier<T> get minx => ValueNotifier<T>(this);
}
