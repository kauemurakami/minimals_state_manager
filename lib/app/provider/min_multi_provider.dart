import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

class MinMultiProvider<T extends MinController> extends InheritedWidget {
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

  static T of<T extends MinController>(BuildContext context) {
    final Type type = T;
    final MinMultiProvider provider =
        context.dependOnInheritedWidgetOfExactType<MinMultiProvider>()!;
    T? controller = provider.controllers.firstWhere((element) {
      return element.runtimeType == type;
    }, orElse: () => throw Exception("Controller of type $type not found"))
        as T?;
    // controller!.setContext(context);
    // print(controller.context.hashCode);
    if (controller == null) {
      throw Exception("Controller of type $type not found");
    }
    return controller;
  }
}
