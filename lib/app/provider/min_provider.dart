import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';
import 'package:minimals_state_manager/app/widgets/inherited_widgets/min_inherited.dart';

/// A standalone provider widget that manages the lifecycle (`onInit`, `onReady`, and `dispose`)
/// of a state manager instance.
///
/// This widget accommodates both custom controller classes extending `MinNotifier` and
/// standard Flutter `ChangeNotifier` implementations. If a `MinNotifier` is provided,
/// its native lifecycle hooks (`onInit` and `onReady`) are triggered automatically.
///
/// Example usage:
/// ```dart
/// MinProvider(
///   create: () => MyViewModel(), // Can be a MinNotifier or a ChangeNotifier
///   child: const MyView(),
/// )
/// ```
class MinProvider<T extends ChangeNotifier> extends StatefulWidget {
  /// The factory function used to instantiate the state notifier.
  final T Function() create;

  /// The widget subtree that will have access to this provider.
  final Widget child;

  const MinProvider({
    super.key,
    required this.create,
    required this.child,
  });

  @override
  State<MinProvider<T>> createState() => _MinProviderState<T>();
}

class _MinProviderState<T extends ChangeNotifier>
    extends State<MinProvider<T>> {
  late final T notifier;

  @override
  void initState() {
    super.initState();
    // 1. Instantiates the your 'Notifier' (viewModel, controller)
    // ChangeNotifier, MinNotifier, ValueNotifier and anothers flutter listenables
    notifier = widget.create();

    // 2. Triggers the specialized initialization ONLY if it's a MinNotifier
    if (notifier is MinNotifier) {
      (notifier as MinNotifier).onInit();
    }

    // 3. Waits for the first frame to safely trigger onReady for MinNotifiers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && notifier is MinNotifier) {
        (notifier as MinNotifier).onReady();
      }
    });
  }

  @override
  void dispose() {
    // 4. Ensures the instance is cleaned up from RAM when popped off the tree
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Passes down the instance using the generic-bounded InheritedNotifier channel
    return MinInherited<T>(
      notifier: notifier,
      child: widget.child,
    );
  }
}
