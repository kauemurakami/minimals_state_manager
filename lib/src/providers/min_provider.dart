import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/src/state/min_notifier.dart';
import 'package:minimals_state_manager/src/providers/min_inherited.dart';

/// A standalone provider widget that manages the lifecycle (`onInit`, `onReady`, and `dispose`)
/// of a state manager instance.
///
/// ### How to use:
///
/// **Registering the provider:**
/// ```dart
/// MinProvider(
///   create: () => MyViewModel(),
///   child: const MyView(),
/// )
/// ```
///
/// **Accessing state inside build() (Rebuilds on change):**
/// ```dart
/// final controller = MinProvider.watch<MyViewModel>(context);
/// ```
///
/// **Accessing state for callbacks/methods (No rebuilds):**
/// ```dart
/// final controller = MinProvider.read<MyViewModel>(context);
/// controller.doSomething();
/// ```
class MinProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() create;
  final Widget child;

  const MinProvider({
    super.key,
    required this.create,
    required this.child,
  });

  /// Accesses the controller and subscribes the context to changes.
  /// Use this inside the [build] method when you need the UI to reflect state changes.
  static T watch<T extends ChangeNotifier>(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<MinInherited<T>>();
    assert(inherited != null, 'No MinProvider<$T> found in context.');
    return inherited!.notifier!;
  }

  /// Accesses the controller without subscribing to changes.
  /// Use this inside event handlers (onPressed, etc.) or callbacks to avoid unnecessary rebuilds.
  static T read<T extends ChangeNotifier>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<MinInherited<T>>();
    assert(element != null, 'No MinProvider<$T> found in context.');
    final inherited = element!.widget as MinInherited<T>;
    return inherited.notifier!;
  }

  @override
  State<MinProvider<T>> createState() => _MinProviderState<T>();
}

class _MinProviderState<T extends ChangeNotifier>
    extends State<MinProvider<T>> {
  late final T notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.create();

    if (notifier is MinNotifier) {
      (notifier as MinNotifier).onInit();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && notifier is MinNotifier) {
        (notifier as MinNotifier).onReady();
      }
    });
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MinInherited<T>(
      notifier: notifier,
      child: widget.child,
    );
  }
}
