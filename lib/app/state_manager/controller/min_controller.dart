import 'package:flutter/widgets.dart';

abstract class MinController with WidgetsBindingObserver {
  void onInit();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      onClose();
    }
  }

  @override
  void onClose() {
    // executa o código do onClose aqui
  }
}
