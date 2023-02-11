import 'package:flutter/widgets.dart';

abstract class MinController with WidgetsBindingObserver {
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

  void onInit();
  @override
  void onClose() {
    // executa o código do onClose aqui
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
    // executa o código do onClose aqui
  }
}
