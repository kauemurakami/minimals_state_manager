import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/provider/min_provider.dart';

class MinView extends StatelessWidget {
  dynamic controller;
  MinView({Key? key, @required this.controller}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    controller = MinProvider.of(context).controller;
    controller!.onInit();

    // TODO: implement build
    throw UnimplementedError();
  }
}
