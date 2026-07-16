import 'package:flutter/widgets.dart';

/// The native flat bridge that propagates a collection of [ChangeNotifier] instances
/// down the widget tree.
///
/// It extends [InheritedWidget] directly instead of [InheritedNotifier] because it acts
/// as a flat registry/container for multiple state managers.
class MinMultiInherited extends InheritedWidget {
  /// The flat collection of active state management layers.
  final List<ChangeNotifier> notifiers;

  /// Creates a [MinMultiInherited] container.
  const MinMultiInherited({
    Key? key,
    required this.notifiers,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  /// Determines if dependent widgets should be notified when the list of
  /// notifiers changes.
  @override
  bool updateShouldNotify(covariant MinMultiInherited oldWidget) {
    return notifiers != oldWidget.notifiers;
  }
}
