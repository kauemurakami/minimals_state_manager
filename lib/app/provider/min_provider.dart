import 'package:flutter/material.dart';

/// A generic [InheritedWidget] that provides a [ChangeNotifier] controller to its descendants.
class MinProvider<T extends ChangeNotifier> extends InheritedWidget {
  /// The controller that will be provided to the widget tree.
  final T controller;

  /// Creates a [MinProvider] widget.
  ///
  /// The [controller] parameter must not be null and is the instance of [ChangeNotifier]
  /// that will be provided to the widget tree.
  /// The [child] parameter must not be null and is the widget below this widget in the tree.
  const MinProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  /// Static method to get the [MinProvider] instance from the context, returning null if not found.
  ///
  /// This method is useful when you want to optionally get the provider without throwing an error
  /// if the provider is not found in the context.
  static MinProvider<T>? maybeOf<T extends ChangeNotifier>(
      BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MinProvider<T>>();
  }

  /// Static method to get the [MinProvider] instance from the context, throwing an error if not found.
  ///
  /// This method is useful when you are certain that the provider exists in the context and want
  /// to ensure access to it. If the provider is not found, an assertion error is thrown.
  static MinProvider<T> of<T extends ChangeNotifier>(BuildContext context) {
    final MinProvider<T>? result = maybeOf<T>(context);
    assert(result != null, 'No MinProvider found in context for $T');
    return result!;
  }

  /// Retrieves the controller of type [T] from the nearest [MinProvider] ancestor in the widget tree.
  ///
  /// Throws a [FlutterError] if no [MinProvider] of type [T] is found in the widget tree.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = MinProvider.read<MyController>(context);
  /// ```
  ///
  /// This method ensures that the widget attempting to access the controller
  /// has a corresponding [MinProvider] above it in the widget hierarchy.
  static T use<T extends ChangeNotifier>(BuildContext context) {
    final provider = maybeOf<T>(context);
    if (provider == null) {
      throw FlutterError(
        'MinProvider<$T> was not found in the widget tree.\n'
        'Make sure MinProvider<$T> is above the widget that '
        'is trying to access it.',
      );
    }
    return provider.controller;
  }

  /// Determines if the widget should notify its dependents when the [controller] changes.
  ///
  /// This method returns true if the current [controller] is different from the old [controller].
  @override
  bool updateShouldNotify(covariant MinProvider<T> oldWidget) =>
      controller != oldWidget.controller;
}
