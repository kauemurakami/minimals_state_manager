import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/src/state/min_notifier.dart';

/// The native reactive bridge that binds a single [MinNotifier] instance to the Flutter widget tree.
///
/// It extends [InheritedNotifier], which automatically registers a listener to the provided
/// [notifier] and triggers a targeted rebuild to dependent descendants whenever `notifyListeners()`
/// is called.
///
/// This widget represents the standalone, strongly-typed connection channel for individual controllers.
///
/// Example usage:
/// ```dart
/// MinInherited<LoginController>(
///   notifier: loginController,
///   child: const MyView(),
/// )
/// ```
class MinInherited<T extends ChangeNotifier> extends InheritedNotifier<T> {
  final String? tag;
  const MinInherited({
    Key? key,
    required T notifier,
    required Widget child,
    this.tag,
  }) : super(
          key: key,
          notifier: notifier,
          child: child,
        );
}
