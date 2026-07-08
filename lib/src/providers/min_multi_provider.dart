import 'package:flutter/widgets.dart';

import '../../min_notifiers.dart';
import 'min_multi_inherited.dart';

/// A multi-provider widget that manages the lifecycle (`onInit`, `onReady`, and `dispose`)
/// of a list of state management instances simultaneously.
///
/// This widget acts as a shared lifecycle capsule for your state architecture. It accepts
/// a heterogeneous list of factory functions returning either your custom [MinNotifier]
/// controllers or standard Flutter [ChangeNotifier] classes (such as `ValueNotifier`).
///
/// If a provided instance inherits from [MinNotifier], its dedicated lifecycle hooks
/// (`onInit` and `onReady`) will be executed automatically. Standard [ChangeNotifier]s
/// will skip these steps safely while still benefiting from automated `dispose` cleanups.
///
/// Example usage:
/// ```dart
/// MinMultiProvider(
///   create: [
///     () => LoginController(),    // Extends MinNotifier
///     () => ValueNotifier<int>(0), // Standard Flutter ChangeNotifier subclass
///   ],
///   child: const MyView(),
/// )
/// ```
class MinMultiProvider extends StatefulWidget {
  /// The list of factory functions used to instantiate the state notifiers or change notifiers.
  final List<ChangeNotifier Function()> create;

  /// The widget subtree that will have access to the provided state managers.
  final Widget child;

  const MinMultiProvider({
    super.key,
    required this.create,
    required this.child,
  });

  @override
  State<MinMultiProvider> createState() => _MinMultiProviderState();

  /// Obtains a state manager of type [T] from the nearest [MinMultiProvider] ancestor,
  /// without listening to future changes or triggering widget rebuilds.
  ///
  /// This method works seamlessly whether the requested class is a custom [MinNotifier]
  /// or a standard [ChangeNotifier].
  ///
  /// Throws a [FlutterError] if the [MinMultiProvider] is not found in the context
  /// or if a notifier of type [T] was not registered in the [create] list.
  ///
  /// Example usage:
  /// ```dart
  /// final loginViewModel = MinMultiProvider.read<LoginViewModel>(context);
  /// ```
  static T read<T extends ChangeNotifier>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<MinMultiInherited>();

    if (element == null) {
      throw FlutterError(
        'MinMultiProvider was not found in the current context.\n'
        'Make sure MinMultiProvider is positioned above this widget in the tree.',
      );
    }

    final provider = element.widget as MinMultiInherited;

    final notifier = provider.notifiers.firstWhere(
      (n) => n is T,
      orElse: () => throw FlutterError(
        'Notifier of type $T was not found in this MinMultiProvider.\n'
        'Verify that you added this state notifier factory to the "create" parameter list.',
      ),
    );

    return notifier as T;
  }

  /// Obtains a state manager of type [T] from the nearest [MinMultiProvider] ancestor,
  /// and registers this [BuildContext] to be dependent on it.
  ///
  /// The widget using this method will automatically rebuild whenever the provider itself
  /// updates its internal notifier references.
  ///
  /// Throws a [FlutterError] if the [MinMultiProvider] is not found in the context
  /// or if a notifier of type [T] was not registered in the [create] list.
  ///
  /// Example usage:
  /// ```dart
  /// final loginController = MinMultiProvider.watch<LoginController>(context);
  /// ```
  static T watch<T extends ChangeNotifier>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MinMultiInherited>();

    if (provider == null) {
      throw FlutterError(
        'MinMultiProvider was not found in the current context.\n'
        'Make sure MinMultiProvider is positioned above this widget in the tree.',
      );
    }

    final notifier = provider.notifiers.firstWhere(
      (n) => n is T,
      orElse: () => throw FlutterError(
        'Notifier of type $T was not found in this MinMultiProvider.\n'
        'Verify that you added this state notifier factory to the "create" parameter list.',
      ),
    );

    return notifier as T;
  }
}

class _MinMultiProviderState extends State<MinMultiProvider> {
  late final List<ChangeNotifier> _notifiers = [];

  @override
  void initState() {
    super.initState();

    // 1. Instantiates each notifier and triggers early lifecycle hooks if applicable.
    for (final createFn in widget.create) {
      final notifier = createFn();
      if (notifier is MinNotifier) {
        notifier.onInit();
      }
      _notifiers.add(notifier);
    }

    // 2. Waits for the first frame to render before safely executing onReady hooks for MinNotifiers.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        for (final notifier in _notifiers) {
          if (notifier is MinNotifier) {
            notifier.onReady();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    // 3. Automatically discards all managed instances to prevent RAM memory leaks.
    for (final notifier in _notifiers) {
      notifier.dispose();
    }
    _notifiers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. Exposes the flat list of instantiated managers down the tree via the separate public InheritedWidget.
    return MinMultiInherited(
      notifiers: _notifiers,
      child: widget.child,
    );
  }
}
