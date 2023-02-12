import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

T? find<T>(BuildContext context) {
  final Type type = T;
  T controller;
  try {
    controller = MinProvider.of(context).controller as T;
  } catch (e) {
    controller = MinMultiProvider.of<T>(context);
    if (controller == null) {
      throw Exception("Controller of type $T not found");
    }
  }

  if (controller == null) {
    throw Exception("Controller of type $type not found");
  }

  return controller;
}
