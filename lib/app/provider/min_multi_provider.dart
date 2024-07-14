import 'package:flutter/material.dart';

/// Provides a way to access multiple controllers from the nearest [MinMultiProvider] ancestor in the widget tree.
class MinMultiProvider extends InheritedWidget {
  final List<ChangeNotifier> controllers;

  const MinMultiProvider({
    Key? key,
    required this.controllers,
    required Widget child,
  }) : super(key: key, child: child);

  /// Retrieves the nearest [MinMultiProvider] from the widget tree, if available.
  static MinMultiProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MinMultiProvider>();
  }

  /// Retrieves a specific controller of type [T] from the nearest [MinMultiProvider] ancestor in the widget tree.
  ///
  /// Throws a [FlutterError] if no [MinMultiProvider] is found in the widget tree or if the controller of type [T] is not found within it.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = MinMultiProvider.use<MyController>(context);
  /// ```
  static T use<T extends ChangeNotifier>(BuildContext context) {
    final provider = maybeOf(context);
    if (provider == null) {
      throw FlutterError(
        'MinMultiProvider was not found in the widget tree.\n'
        'Make sure MinMultiProvider is above the widget that '
        'is trying to access it.',
      );
    }

    final controller = provider.controllers.firstWhere(
      (c) => c is T,
      orElse: () => throw FlutterError(
        'Controller of type $T not found in MinMultiProvider.\n'
        'Make sure the controller is added to the MinMultiProvider.',
      ),
    );

    return controller as T;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is MinMultiProvider) {
      return controllers != oldWidget.controllers;
    }
    return true;
  }
}
