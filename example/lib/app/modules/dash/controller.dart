import 'package:example/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final pages = [Routes.HOME, Routes.PROFILE, Routes.ESTABLISHMENTS];
  @override
  void onInit() {
    print('dash controller');
    super.onInit();
  }

  var index = 0.minx;
  void changePage(int _, BuildContext context) async {
    if (index.value != _) {
      index.value = _;
      navigatorKey.currentState!.pushReplacementNamed(pages[_]);
    }

    // notifyListeners();
  }
}
