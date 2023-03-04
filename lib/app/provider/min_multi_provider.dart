import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/controller/permament_controller.dart';

///A provider widget that provides multiple instances of [MinController] to its descendants
///via [context].
///It uses [InheritedWidget] to share the controllers across the widget tree.

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

  /// Returns the instance of T from the closest ancestor MinMultiProvider
  /// widget that matches the type T.
  static T of<T extends MinController>(BuildContext context) {
    // final Type type = T;
    final MinMultiProvider? provider =
        context.dependOnInheritedWidgetOfExactType<MinMultiProvider>();

    T? controller =
        provider?.controllers.whereType<T>().firstWhere((element) => true);
    if (controller == null) {
      try {
        controller = MinService.of<T>();
      } catch (e) {
        throw Exception('Controller $T not found');
      }
    }
    return controller;
  }
}
