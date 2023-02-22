import 'package:flutter/widgets.dart';

/// Abstract class for creating controllers in Flutter applications.
///
/// [MinController] is used to manage the state of a widget or group of widgets.
/// It implements [ChangeNotifier] and [WidgetsBindingObserver].

abstract class MinController extends ChangeNotifier
    with WidgetsBindingObserver {
  BuildContext? _context;

  /// Initializes the controller.
  MinController() {
    onInit();
  }

  /// Performs initialization when the controller is created.
  void onInit() {
    // loaded = true;
  }

  /// Get the [BuildContext].
  BuildContext get context => _context!;

  /// Sets the [BuildContext].
  setContext(c) => _context = c;

  /// Executes code on close.
  @override
  void onClose() {
    // executa o código do onClose aqui
    // loaded = false;
  }

  /// Executes code when the application is in the inactive state.
  @override
  void onInactived() {
    // executa o código do onClose aqui
  }

  /// Executes code when the application is in the paused state.
  @override
  void onPaused() {
    // executa o código do onClose aqui
  }

  /// Executes code when the application is in the resumed state.
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
