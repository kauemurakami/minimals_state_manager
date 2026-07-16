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
/// or
/// ```dart
/// MinProvider(
///   create: () => MyViewModel(),
///   child: const MyView(),
/// )
/// ```
/// ```dart
/// //or usage with tag
///  MinProvider(
///   create: () => MyViewModel(),
///   tag: 'page1',
///   child: const MyView(),
/// )
/// ```
/// **Accessing state inside build() (Rebuilds on change):**
/// ```dart
/// final notifier = MinProvider.watch<MyNotifier>(context);
/// //with tag
/// final notifier = MinProvider.watch<MyNotifier>(context, tag: 'page1');
/// ```
///
/// **Accessing state for callbacks/methods (No rebuilds):**
/// ```dart
/// final notifier = MinProvider.read<MyNotifier>(context);
/// //usage with tags
/// final notifier = MinProvider.read<MyNotifier>(context, tag: 'page1');
/// controller.doSomething();
/// ```
/// //or use provider_extensions
/// ```dart
/// final notifier = context.read<MyNotifier>(tag: 'page1');
/// final notifier = context.watch<MyNotifier>(tag: 'page1');
/// ```
class MinProvider<T extends ChangeNotifier> extends StatefulWidget {
  /// A function or instance that creates the notifier to be provided.
  final T Function() create;

  /// link a instance notifier a one tag
  final String? tag;

  /// The widget below this provider in the tree, which will have
  /// access to the provided controller.
  final Widget child;

  /// Creates a [MinProvider] to inject a single controller
  /// into the widget tree.
  const MinProvider({
    super.key,
    required this.create,
    this.tag,
    required this.child,
  });

  /// Accesses the controller without subscribing to changes.
  ///
  /// Use this inside event handlers (onPressed, etc.) or callbacks to avoid
  /// unnecessary rebuilds. If a [tag] is provided, it specifically searches for
  /// the instance associated with that tag. If no [tag] is provided, it returns
  /// the nearest instance of [T] found in the widget tree.
  ///
  /// Throws a [FlutterError] if no [MinProvider] for [T] is found, or if
  /// a specific [tag] was requested but not found in the ancestor chain.
  static T read<T extends ChangeNotifier>(BuildContext context, {String? tag}) {
    return _findNotifier<T>(context, tag, false).notifier!;
  }

  /// Accesses the controller and subscribes the context to changes.
  ///
  /// Use this inside the `build` method when you need the UI to reflect state changes.
  /// If a [tag] is provided, it specifically searches for the instance associated with
  /// that tag. If no [tag] is provided, it returns the nearest instance of [T].
  ///
  /// Throws a [FlutterError] if no [MinProvider] for [T] is found, or if
  /// a specific [tag] was requested but not found in the ancestor chain.
  static T watch<T extends ChangeNotifier>(BuildContext context,
      {String? tag}) {
    final target = _findNotifier<T>(context, tag, true);

    // Se o 'target' não foi o que veio no dependOnInheritedWidgetOfExactType inicial,
    // precisamos nos inscrever especificamente no 'target' via aspect.
    return context
        .dependOnInheritedWidgetOfExactType<MinInherited<T>>(aspect: target)!
        .notifier!;
  }

  /// Internal helper to locate the correct MinInherited instance.
  static MinInherited<T> _findNotifier<T extends ChangeNotifier>(
      BuildContext context, String? tag, bool listen) {
    // 1. Busca inicial
    final inherited = listen
        ? context.dependOnInheritedWidgetOfExactType<MinInherited<T>>()
        : context
            .getElementForInheritedWidgetOfExactType<MinInherited<T>>()
            ?.widget as MinInherited<T>?;

    if (inherited == null) {
      throw FlutterError('MinProvider<$T> not found in the current context.');
    }

    // 2. Se a tag bater, retorna o encontrado
    if (tag == null || inherited.tag == tag) {
      return inherited;
    }

    // 3. Caso contrário, sobe a árvore
    MinInherited<T>? target;
    context.visitAncestorElements((ancestor) {
      if (ancestor.widget is MinInherited<T>) {
        final w = ancestor.widget as MinInherited<T>;
        if (w.tag == tag) {
          target = w;
          return false;
        }
      }
      return true;
    });

    if (target == null) {
      throw FlutterError('MinProvider<$T> with tag "$tag" not found.');
    }

    return target!;
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

    // notifier.addListener(() => setState(() {}));

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
      tag: widget.tag,
      child: widget.child,
    );
  }
}
