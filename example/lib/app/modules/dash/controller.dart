import 'package:example/routes/delegate.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController {
  var index = 0.minx;
  void changePage(int _, BuildContext context) async {
    index.value = _;
    switch (_) {
      case 0:
        await MyRouterDelegate(pages: [])
            .navigatorKey!
            .currentState!
            .pushNamed('/home');
        // await Navigator.of(context).pushNamed('/home');
        break;
      case 1:
        await MyRouterDelegate(pages: [])
            .navigatorKey!
            .currentState!
            .pushNamed('/profile');
        // await Navigator.of(context).pushNamed('/profile');
        break;
      default:
    }

    // notifyListeners();
  }
}
