import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

// A provider for a [MinController] that allows to access the controller
/// using [BuildContext]. It inherits from [InheritedWidget].
///
/// Use [of] to access the controller instance, and [updateShouldNotify] to
/// determine whether the widget should be rebuilt or not.
class MinProvider<T extends MinController> extends InheritedWidget {
  final T? controller;

  const MinProvider({
    Key? key,
    required Widget child,
    this.controller,
  }) : super(key: key, child: child);

  static T? of<T extends MinController>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MinProvider<T>>();
    return provider?.controller;
  }

  @override
  bool updateShouldNotify(MinProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
