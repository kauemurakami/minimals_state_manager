import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/provider/min_provider.dart';

class MinWidget<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T controller) builder;

  const MinWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final T controller = MinProvider.of(context).controller;
    return Builder(
      builder: (BuildContext context) => builder(context, controller),
    );
  }
}
