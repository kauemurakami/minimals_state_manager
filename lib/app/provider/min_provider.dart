import 'package:flutter/widgets.dart';

class MinProvider extends InheritedWidget {
  final controller;

  MinProvider({Key? key, @required Widget? child, this.controller})
      : super(key: key, child: child!);

  static MinProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MinProvider>()!;
  }

  @override
  bool updateShouldNotify(MinProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
