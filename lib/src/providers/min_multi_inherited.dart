import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/src/state/min_notifier.dart';

/// The native flat bridge that propagates a collection of [MinNotifier] instances down the tree.
///
/// It extends [InheritedWidget] directly instead of [InheritedNotifier] because it acts
/// as a flat registry/container for multiple state managers.
class MinMultiInherited extends InheritedWidget {
  /// The flat collection of active state management layers ([MinNotifier]/[ChangeNotifier]).
  final List<ChangeNotifier> notifiers;

  const MinMultiInherited({
    Key? key,
    required this.notifiers,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant MinMultiInherited oldWidget) {
    return notifiers != oldWidget.notifiers;
  }
}
