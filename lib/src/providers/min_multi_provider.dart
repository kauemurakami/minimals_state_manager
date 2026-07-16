import 'package:flutter/widgets.dart';
import '../state/min_notifier.dart';
import '../types/tagged_notifier.dart';
import 'min_multi_inherited.dart';

/// A multi-provider widget that manages the lifecycle (initialization, readiness,
/// and disposal) of a collection of state management instances simultaneously.
///
/// It accepts a list of objects, supporting either raw factory functions `() => MyNotifier()`
/// or tagged instances defined via [TaggedNotifier] (using the `.tag()` extension).
///
/// Example usage:
/// ```dart
/// MinMultiProvider(
///   notifiers: [
///     () => LoginController(),
///     () => LoginController().tag('admin'),
///   ],
///   child: const MyView(),
/// )
/// ```
class MinMultiProvider extends StatefulWidget {
  final List<Object> create;
  final Widget child;

  MinMultiProvider({super.key, required this.create, required this.child}) {
    // Validação que garante que a lista não esteja vazia
    if (create.isEmpty) {
      throw FlutterError(
        'MinMultiProvider: The "create" list cannot be empty. '
        'You must provide at least one notifier provider.',
      );
    }
  }

  @override
  State<MinMultiProvider> createState() => _MinMultiProviderState();

  /// Obtains a state manager of type [T] from the nearest [MinMultiProvider] ancestor.
  ///
  /// This method performs an exact match for the [tag]. If [tag] is null, it retrieves
  /// the instance registered without a tag. If the instance is not found,
  /// it throws a descriptive [FlutterError].
  static T read<T extends ChangeNotifier>(BuildContext context, {String? tag}) {
    return _findNotifier<T>(context, tag: tag);
  }

  /// Obtains a state manager of type [T] and registers the [BuildContext]
  /// to rebuild when the provider container triggers a notification.
  ///
  /// Similar to [read], this method performs an exact match for the [tag].
  /// If the instance is not found, it throws a descriptive [FlutterError].
  static T watch<T extends ChangeNotifier>(BuildContext context,
      {String? tag}) {
    // 1. First, find the notifier using the internal helper
    final notifier = _findNotifier<T>(context, tag: tag);

    // 2. Subscribe to the inherited widget to trigger rebuilds
    context.dependOnInheritedWidgetOfExactType<MinMultiInherited>();

    return notifier;
  }

  /// Internal helper to locate the notifier in the tree.
  static T _findNotifier<T extends ChangeNotifier>(BuildContext context,
      {String? tag}) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<MinMultiInherited>();

    if (inherited == null) {
      throw FlutterError(
        'MinMultiProvider: No MinMultiInherited found. '
        'Ensure that a MinMultiProvider is present above the current context.',
      );
    }

    final entry = inherited.instances.firstWhere(
      (item) => item.notifier is T && item.tag == tag,
      orElse: () {
        throw FlutterError(
          'MinMultiProvider: Notifier of type $T ${tag != null ? 'with tag "$tag"' : 'without a tag'} was not found.',
        );
      },
    );

    return entry.notifier as T;
  }
}

/// The state class that handles initialization and lifecycle for multiple notifiers.
class _MinMultiProviderState extends State<MinMultiProvider> {
  // Holds the instantiated controllers and their associated tags
  final List<({ChangeNotifier notifier, String? tag})> _instances = [];

  @override
  void initState() {
    super.initState();

    for (final item in widget.create) {
      // 1. Resolve the factory function (if it is a function, execute it to get the instance or record)
      final result = (item is Function) ? (item as Function)() : item;

      ChangeNotifier? notifier;
      String? tag;

      // 2. Check if the result is a TaggedNotifier (a record containing a create function and a tag)
      if (result is ({ChangeNotifier Function() create, String? tag})) {
        notifier = result.create();
        tag = result.tag;
      }
      // 3. Handle cases where the result is already a direct ChangeNotifier instance (untagged)
      else if (result is ChangeNotifier) {
        notifier = result;
        tag = null;
      }

      if (notifier != null) {
        // Initialize custom MinNotifier lifecycle if applicable
        if (notifier is MinNotifier) notifier.onInit();

        // Add the resolved notifier and its tag to the instance registry
        _instances.add((notifier: notifier, tag: tag));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Propagate the live instances to the inherited widget
    return MinMultiInherited(
      instances: _instances,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    // Clean up all instances when the provider is removed from the tree
    for (final entry in _instances) {
      entry.notifier.dispose();
    }
    super.dispose();
  }
}
