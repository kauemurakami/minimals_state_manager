import 'package:flutter/widgets.dart';

abstract class MinController with WidgetsBindingObserver {
  // bool loaded = false;
  // MinController() {
  //   onInit();
  // }
  void onInit() {
    // loaded = true;
  }

  @override
  void onClose() {
    // executa o código do onClose aqui
    // loaded = false;
  }

  @override
  void onInactived() {
    // executa o código do onClose aqui
  }
  @override
  void onPaused() {
    // executa o código do onClose aqui
  }
  @override
  void onResumed() {
    // loaded = true;
    // executa o código do onClose aqui
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      onClose();
    }
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
    if (state == AppLifecycleState.paused) {
      onPaused();
    }
    if (state == AppLifecycleState.inactive) {
      onInactived();
    }
  }
}
