import 'package:flutter/widgets.dart';

extension ValueNotifierUpdater<T> on ValueNotifier<T> {
  void update(Function(T) update) {
    T value = this.value;
    update(value);
    this.value = value;
    notifyListeners();
  }
}
