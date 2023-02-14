import 'package:example/routes/delegate.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController {
  var index = 0.minx;
  void changePage(int _, BuildContext context) async {
    index.value = _;
    // notifyListeners();
  }
}
