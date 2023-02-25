import 'package:example/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController {
  ValueNotifier<int> index = 0.minx;
  // or final index = 0.minx;

  final pages = [
    Routes.HOME,
    Routes.PROFILE,
  ];
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('dash widget render');
    });
    print('dash controller init');
    super.onInit();
  }

  changePage(int _) {
    // print('_ $_  index ${index.value}');
    if (index.value != _) {
      index.value = _;
      return pages[_];
    }
  }
}
