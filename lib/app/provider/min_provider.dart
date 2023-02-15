import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

// class MinProvider extends InheritedWidget {
//   final controller;

//   MinProvider({Key? key, @required Widget? child, this.controller})
//       : super(key: key, child: child!);

//   static MinProvider of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<MinProvider>()!;
//   }

//   @override
//   bool updateShouldNotify(MinProvider oldWidget) {
//     return controller != oldWidget.controller;
//   }
// }
class MinProvider<T extends MinController> extends InheritedWidget {
  final T Function() create;
  final T? controller;

  const MinProvider({
    Key? key,
    required Widget child,
    required this.create,
    this.controller,
  }) : super(key: key, child: child);

  static T of<T extends MinController>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MinProvider<T>>();
    if (provider != null && provider.controller != null) {
      return provider.controller!;
    }
    final controller = provider?.create();
    if (controller != null) {
      return controller;
    }
    throw Exception('Controller of type $T not found');
  }

  @override
  bool updateShouldNotify(MinProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
