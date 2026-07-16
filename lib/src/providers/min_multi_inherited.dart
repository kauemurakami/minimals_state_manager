import 'package:flutter/widgets.dart';

/// The native flat bridge that propagates a collection of [ChangeNotifier] instances
/// down the widget tree.
///
/// It extends [InheritedWidget] directly instead of [InheritedNotifier] because it acts
/// as a flat registry/container for multiple state managers.
/// An [InheritedWidget] that stores a map of tagged state managers.
///
/// It exposes the [taggedNotifiers] to the widget tree, allowing
/// [MinMultiProvider] to perform efficient lookups.
class MinMultiInherited extends InheritedWidget {
  final List<({ChangeNotifier notifier, String? tag})> instances;

  const MinMultiInherited({
    super.key,
    required this.instances,
    required super.child,
  });

  @override
  bool updateShouldNotify(MinMultiInherited oldWidget) =>
      instances != oldWidget.instances;
}
