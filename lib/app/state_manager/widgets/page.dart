import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/provider/min_provider.dart';

class MinView<T> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;
  const MinView({Key? key, required this.builder}) : super(key: key);
  T getController(BuildContext context) =>
      MinProvider.of(context).controller as T;
  @override
  Widget build(BuildContext context) {
    return builder(context, getController(context));
  }
}
