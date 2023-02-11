import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

class MinX<T extends MinController> extends StatelessWidget {
  final Widget Function(BuildContext context, T controller) builder;

  const MinX({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final T controller = MinProvider.of(context).controller as T;
    T controller;
    try {
      controller = MinProvider.of(context).controller as T;
    } catch (e) {
      controller = MinMultiProvider.of<T>(context);
      if (controller == null) {
        throw Exception("Controller of type $T not found");
      }
    }
    return Builder(
      builder: (BuildContext context) => builder(context, controller),
    );
  }
}
