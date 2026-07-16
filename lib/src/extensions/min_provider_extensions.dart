import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/src/providers/min_inherited.dart';
import 'package:minimals_state_manager/src/providers/min_multi_inherited.dart';

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
  /// class MyNotifier extends `ChangeNotifier` { ... }
  /// or
  /// class MyNotifier extends `MinNotifier` { ... }
  /// usage :
  /// final notifier = context.watch<MyNotNotifier>()
  /// or using tag
  /// final notifier = context.watch<MyNotNotifier>(tag: 'page1')
  /// Optionally, you can provide a [tag] to perform a precise lookup. If the instance
  /// is not found, it throws a descriptive [FlutterError].
  /// ```
  T watch<T extends ChangeNotifier>({String? tag}) {
    // 1. Try to look up the single-provider channel
    final inheritedIndividual =
        dependOnInheritedWidgetOfExactType<MinInherited<T>>();
    if (inheritedIndividual != null && inheritedIndividual.notifier != null) {
      return inheritedIndividual.notifier!;
    }

    // 2. Fall back to the multi-provider flat registry
    final inheritedMulti =
        dependOnInheritedWidgetOfExactType<MinMultiInherited>();
    if (inheritedMulti != null) {
      final entry = inheritedMulti.instances.firstWhere(
        (item) => item.notifier is T && item.tag == tag,
        orElse: () {
          if (tag != null) {
            throw FlutterError(
                'MinMultiProvider: Notifier of type $T with tag "$tag" was not found.\n'
                'Ensure you registered this specific notifier with .tag("$tag").');
          } else {
            throw FlutterError(
                'MinMultiProvider: Notifier of type $T without a tag was not found.\n'
                'Ensure you registered this notifier without calling .tag().');
          }
        },
      );
      return entry.notifier as T;
    }

    throw FlutterError(
        'No MinProvider<$T> or MinMultiProvider found in the current context.\n'
        'Make sure a provider is positioned above this widget in the tree.');
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
  /// class MyNotifier extends ChangeNotifier { ... }
  /// or
  /// class MyNotifier extends MinNotifier { ... }
  /// usage :
  /// final notifier = context.read<MyNotifier>();
  /// or using tag
  /// final notifier = context.read<MyNotifier>(tag: 'page1');
  /// ```
  /// Optionally, you can provide a [tag] to perform a precise lookup. If the instance
  /// is not found, it throws a descriptive [FlutterError].
  T read<T extends ChangeNotifier>({String? tag}) {
    // 1. Try to look up the single-provider channel element
    final elementIndividual =
        getElementForInheritedWidgetOfExactType<MinInherited<T>>();
    if (elementIndividual != null) {
      return (elementIndividual.widget as MinInherited<T>).notifier!;
    }

    // 2. Fall back to the multi-provider flat registry element
    final elementMulti =
        getElementForInheritedWidgetOfExactType<MinMultiInherited>();
    if (elementMulti != null) {
      final inherited = elementMulti.widget as MinMultiInherited;
      final entry = inherited.instances.firstWhere(
        (item) => item.notifier is T && item.tag == tag,
        orElse: () {
          if (tag != null) {
            throw FlutterError(
                'MinMultiProvider: Notifier of type $T with tag "$tag" was not found.\n'
                'Ensure you registered this specific notifier with .tag("$tag").');
          } else {
            throw FlutterError(
                'MinMultiProvider: Notifier of type $T without a tag was not found.\n'
                'Ensure you registered this notifier without calling .tag().');
          }
        },
      );
      return entry.notifier as T;
    }

    throw FlutterError(
        'No MinProvider<$T> or MinMultiProvider found in the current context.\n'
        'Make sure a provider is positioned above this widget in the tree.');
  }
}
