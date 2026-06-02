import 'package:flutter/widgets.dart';

/// O link nativo com o ecossistema do Flutter (100% Corrigido)
class MinInheritedNotifier<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  const MinInheritedNotifier({
    Key? key, // Declarado de forma tradicional
    required T notifier,
    required Widget child,
  }) : super(
          key: key, // Repassado explicitamente
          notifier: notifier,
          child: child,
        );
}
