import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

class MinMultiProvider extends InheritedWidget {
  final List<MinController> controllers;

  const MinMultiProvider({
    Key? key,
    required Widget child,
    required this.controllers,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(MinMultiProvider oldWidget) {
    return controllers != oldWidget.controllers;
  }

  static T of<T>(BuildContext context) {
    final Type type = T;
    final MinMultiProvider provider =
        context.dependOnInheritedWidgetOfExactType<MinMultiProvider>()!;
    final T? controller = provider.controllers.firstWhere(
            (element) => element.runtimeType == type,
            orElse: () => throw Exception("Controller of type $type not found"))
        as T?;

    if (controller == null) {
      throw Exception("Controller of type $type not found");
    }

    return controller;
  }
}
