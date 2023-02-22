import 'package:flutter/src/foundation/change_notifier.dart';

// class MinExtensions with ChangeNotifier {
//   void update(Function(T) update) {
//     T value = this.value;
//     update(value);
//     this.value = value;
//     notifyListeners();
//   }
// }
//abstrair metodo para que possamos usar o change notifier

/// The ValueNotifierUpdater extension provides an update method for ValueNotifier objects,
/// allowing you to update their values while notifying listeners.
/// The extension method accepts a function that takes the current value of the ValueNotifier and
/// returns a new value. It updates the ValueNotifier with the new value, notifies its
/// listeners, and keeps the reference to the same instance of the ValueNotifier.
extension ValueNotifierUpdater<T> on ValueNotifier<T> {
  void update(Function(T) update) {
    T value = this.value;
    update(value);
    this.value = value;
    notifyListeners();
  }
}
