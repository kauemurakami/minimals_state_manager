import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/widgets/inherited_widgets/min_inherited.dart';
import 'package:minimals_state_manager/app/widgets/inherited_widgets/min_multi_inherited.dart';

/// Context extensions to easily retrieve state managers from the widget tree.
///
/// These extensions work seamlessly with both custom class controllers extending
/// `MinNotifier` and standard Flutter `ChangeNotifier` classes.
extension ProviderExtension on BuildContext {
  /// Obtains a state notifier of type [T] from the nearest ancestor and registers
  /// this [BuildContext] to be dependent on it.
  ///
  /// The widget using this method will automatically rebuild whenever the notifier
  /// calls `notifyListeners()`.
  ///
  /// This method looks up through both standalone `MinProvider` and `MinMultiProvider` containers.
  ///
  /// Example:
  /// ```dart
  /// class MyViewModel extends `ChangeNotifier` { ... }
  /// or
  /// class MyViewModel extends `MinNotifier` { ... }
  /// usage :
  /// final myViewModel = context.watch<MyViewModel>();
  /// ```
  T watch<T extends ChangeNotifier>() {
    // 1. Tries to look up the single-provider channel
    final inheritedIndividual =
        dependOnInheritedWidgetOfExactType<MinInherited<T>>();
    if (inheritedIndividual != null && inheritedIndividual.notifier != null) {
      return inheritedIndividual.notifier!;
    }

    // 2. If not found, falls back to the multi-provider flat registry
    final inheritedMulti =
        dependOnInheritedWidgetOfExactType<MinMultiInherited>();
    if (inheritedMulti != null) {
      final notifier = inheritedMulti.notifiers.firstWhere(
        (c) => c is T,
        orElse: () => throw Exception(
            'Notifier of type $T was not found in MinMultiProvider.'),
      );
      return notifier as T;
    }

    throw Exception(
        'No MinProvider<$T> or MinMultiProvider found in the current context.');
  }

  /// Obtains a state notifier of type [T] from the nearest ancestor without
  /// registering a dependency or triggering widget rebuilds.
  ///
  /// Use this inside lifecycle callbacks or event handlers (e.g., `onPressed`) where
  /// you only need to trigger methods or mutations on the state manager.
  ///
  /// This method looks up through both standalone `MinProvider` and `MinMultiProvider` containers.
  ///
  /// Example:
  /// ```dart
  /// class MyViewModel extends ChangeNotifier { ... }
  /// or
  /// class MyViewModel extends MinNotifier { ... }
  /// usage :
  /// final myViewModel = context.read<MyViewModel>();
  /// ```
  T read<T extends ChangeNotifier>() {
    // 1. Tries to look up the single-provider channel element
    final elementIndividual =
        getElementForInheritedWidgetOfExactType<MinInherited<T>>();
    if (elementIndividual != null) {
      return (elementIndividual.widget as MinInherited<T>).notifier!;
    }

    // 2. If not found, falls back to the multi-provider flat registry element
    final elementMulti =
        getElementForInheritedWidgetOfExactType<MinMultiInherited>();
    if (elementMulti != null) {
      final provider = elementMulti.widget as MinMultiInherited;
      final notifier = provider.notifiers.firstWhere(
        (c) => c is T,
        orElse: () => throw Exception(
            'Notifier of type $T was not found in MinMultiProvider.'),
      );
      return notifier as T;
    }

    throw Exception(
        'No MinProvider<$T> or MinMultiProvider found in the current context.');
  }
}
