import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

/**
 * [MinX<MinController>] is a generic widget that simplifies the process of getting a controller instance and 
 * providing it to a widget's tree.
 * The [builder] function will be executed passing the [context] and the [controller] instance as arguments.
 */
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
      controller = MinProvider.of<T>(context) as T;
    } catch (e) {
      controller = MinMultiProvider.of<T>(context);
      // if (controller == null) {
      //   throw Exception("Controller of type $T not found");
      // }
    }
    return Builder(
      builder: (BuildContext context) => builder(context, controller),
    );
  }
}
