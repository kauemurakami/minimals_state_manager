import 'package:flutter/foundation.dart';

/// The ValueNotifierUpdater extension provides an update method for ValueNotifier objects,
/// allowing you to update their values while notifying listeners.
/// The extension method accepts a function that takes the current value of the ValueNotifier and
/// returns a new value. It updates the ValueNotifier with the new value, notifies its
/// listeners, and keeps the reference to the same instance of the ValueNotifier.

extension ValueNotifierUpdater<T> on ValueNotifier<T> {
  void update(void Function(T) update) {
    T value = this.value;
    update(value);
    this.value = value;

    // Se o notifier é um ChangeNotifier, tentamos notificar os ouvintes
    if (this is ChangeNotifier) {
      try {
        (this as ChangeNotifier).notifyListeners();
      } catch (e, stackTrace) {
        // Em caso de erro, tratamos para evitar problemas de runtime
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
          library: 'Flutter SDK',
          context: ErrorDescription('during notifyListeners()'),
        ));
      }
    } else {
      // Lançamos um erro se tentar usar com um ValueNotifier que não é um ChangeNotifier
      throw FlutterError('ValueNotifier is not a subtype of ChangeNotifier. '
          'notifyListeners() can only be called on ChangeNotifier or its subclasses.');
    }
  }
}


// abstrair notifylisteners
// class MinUpdater<T> extends ChangeNotifier {
//   ValueNotifier<T> _notifier;

//   MinUpdater(this._notifier);

//   void update(Function(T) update) {
//     T value = _notifier.value;
//     update(value);
//     _notifier.value = value;
//     notifyListeners();
//   }
// }

// extension ValueNotifierUpdater<T> on ValueNotifier<T> {
//   void update(Function(T) update) => MinUpdater<T>(this).update(update);
// }