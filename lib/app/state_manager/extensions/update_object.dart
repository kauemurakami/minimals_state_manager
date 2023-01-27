import 'package:flutter/foundation.dart';

extension UpdateRxObject<T> on ValueNotifier<T> {
  void update(void Function(T) callback) {
    print(this.value);
    var v = this;
    final newValue = v;
    callback(newValue.value);
    value = newValue.value;

    this.notifyListeners();
  }
}

abstract class Copyable<T> {
  T copy();
}
