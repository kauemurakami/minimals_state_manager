import 'package:flutter/foundation.dart';

extension StringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  ValueNotifier<String> get minx => ValueNotifier<String>(this);
}

extension IntExtension on int {
  /// Returns a `RxInt` with [this] `int` as initial value.
  ValueNotifier<int> get minx => ValueNotifier<int>(this);
}

extension DoubleExtension on double {
  /// Returns a `RxDouble` with [this] `double` as initial value.
  ValueNotifier<double> get minx => ValueNotifier<double>(this);
}

extension BoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  ValueNotifier<bool> get minx => ValueNotifier<bool>(this);
}

extension RxT<T> on T {
  /// Returns a `Rx` instance with [this] `T` as initial value.
  ValueNotifier<T> get minx => ValueNotifier<T>(this);
}
