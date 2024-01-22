import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController {
  final currentIndex = 0.minx;
  // or final index = 0.minx;

  // final pages = [
  //   DashRoutes.home,
  //   DashRoutes.profile,
  //   DashRoutes.other,
  // ];

  final pages = [
    'home',
    'profile',
    'other',
  ];

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('dash widget render');
    });
    print('dash controller init');
    super.onInit();
  }

  goChangePage(int _, BuildContext context) {
    if (currentIndex.value != _) {
      currentIndex.value = _;
      context.push(
        pages[_],
      );
    }
  }
}
