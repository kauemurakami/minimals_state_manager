import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

T? find<T extends MinController>(BuildContext context) {
  final Type type = T;
  T controller;
  try {
    controller = MinProvider.of<T>(context);
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
