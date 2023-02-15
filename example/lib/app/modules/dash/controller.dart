import 'package:example/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class DashController extends MinController with ChangeNotifier {
  GlobalKey<NavigatorState>? navigatorKey;
  final pages = [Routes.HOME, Routes.PROFILE, Routes.ESTABLISHMENTS];
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey = GlobalKey<NavigatorState>();
      // Executa após o widget ser renderizado
      //na tela
      print('Widget foi renderizado');
    });
    print('dash controller');

    super.onInit();
  }

  ValueNotifier<int> index = 0.minx;
  String? changePage(int _) {
    print('_ $_  index ${index.value}');
    if (index.value != _) {
      index.value = _;
      notifyListeners();
      return pages[_];
    }
  }
}
