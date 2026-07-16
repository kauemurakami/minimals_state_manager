import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// A concrete implementation of [AppLifecycleMixin] to verify callback execution.
/// We call `super` inside overrides to ensure the mixin's default implementation is executed.
class TestLifecycleController with AppLifecycleMixin {
  bool resumedCalled = false;
  bool inactiveCalled = false;
  bool pausedCalled = false;
  bool hiddenCalled = false;
  bool detachedCalled = false;
  bool lifecycleChangedCalled = false;
  bool memoryPressureCalled = false;
  bool platformBrightnessCalled = false;
  bool localesChangedCalled = false;
  bool accessibilityChangedCalled = false;
  bool metricsChangedCalled = false;
  bool viewFocusChangedCalled = false;
  bool textScaleFactorCalled = false;
  bool statusBarTapCalled = false;
  bool popRouteCalled = false;
  bool pushRouteCalled = false;
  bool pushRouteInfoCalled = false;
  bool requestAppExitCalled = false;

  @override
  void onResumed() {
    super.onResumed();
    resumedCalled = true;
  }

  @override
  void onInactive() {
    super.onInactive();
    inactiveCalled = true;
  }

  @override
  void onPaused() {
    super.onPaused();
    pausedCalled = true;
  }

  @override
  void onHidden() {
    super.onHidden();
    hiddenCalled = true;
  }

  @override
  void onDetached() {
    super.onDetached();
    detachedCalled = true;
  }

  @override
  void onLifecycleChanged(AppLifecycleState s) {
    super.onLifecycleChanged(s);
    lifecycleChangedCalled = true;
  }

  @override
  void onMemoryPressure() {
    super.onMemoryPressure();
    memoryPressureCalled = true;
  }

  @override
  void onPlatformBrightnessChanged() {
    super.onPlatformBrightnessChanged();
    platformBrightnessCalled = true;
  }

  @override
  void onLocalesChanged(List<Locale>? l) {
    super.onLocalesChanged(l);
    localesChangedCalled = true;
  }

  @override
  void onAccessibilityFeaturesChanged() {
    super.onAccessibilityFeaturesChanged();
    accessibilityChangedCalled = true;
  }

  @override
  void onMetricsChanged() {
    super.onMetricsChanged();
    metricsChangedCalled = true;
  }

  @override
  void onViewFocusChanged(ViewFocusEvent e) {
    super.onViewFocusChanged(e);
    viewFocusChangedCalled = true;
  }

  @override
  void onChangeTextScaleFactor() {
    super.onChangeTextScaleFactor();
    textScaleFactorCalled = true;
  }

  @override
  void onHandleStatusBarTap() {
    super.onHandleStatusBarTap();
    statusBarTapCalled = true;
  }

  @override
  Future<bool> onPopRoute() async {
    await super.onPopRoute();
    popRouteCalled = true;
    return true;
  }

  @override
  Future<bool> onPushRoute(String r) async {
    await super.onPushRoute(r);
    pushRouteCalled = true;
    return true;
  }

  @override
  Future<bool> onPushRouteInformation(RouteInformation i) async {
    await super.onPushRouteInformation(i);
    pushRouteInfoCalled = true;
    return true;
  }

  @override
  Future<AppExitResponse> onRequestAppExit() async {
    await super.onRequestAppExit();
    requestAppExitCalled = true;
    return AppExitResponse.exit;
  }
}

void main() {
  group('AppLifecycleMixin Coverage Tests', () {
    late TestLifecycleController controller;

    setUp(() {
      controller = TestLifecycleController();
    });

    test('Should trigger all lifecycle state changes and switch branches', () {
      // By calling didChangeAppLifecycleState, we trigger the internal switch statement
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(controller.resumedCalled, isTrue);

      controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
      expect(controller.inactiveCalled, isTrue);

      controller.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(controller.pausedCalled, isTrue);

      controller.didChangeAppLifecycleState(AppLifecycleState.hidden);
      expect(controller.hiddenCalled, isTrue);

      controller.didChangeAppLifecycleState(AppLifecycleState.detached);
      expect(controller.detachedCalled, isTrue);

      expect(controller.lifecycleChangedCalled, isTrue);
    });

    test('Should trigger all system observer methods', () {
      controller.didHaveMemoryPressure();
      expect(controller.memoryPressureCalled, isTrue);

      controller.didChangePlatformBrightness();
      expect(controller.platformBrightnessCalled, isTrue);

      controller.didChangeLocales(null);
      expect(controller.localesChangedCalled, isTrue);

      controller.didChangeAccessibilityFeatures();
      expect(controller.accessibilityChangedCalled, isTrue);

      controller.didChangeMetrics();
      expect(controller.metricsChangedCalled, isTrue);

      controller.didChangeTextScaleFactor();
      expect(controller.textScaleFactorCalled, isTrue);

      controller.didChangeViewFocus(const ViewFocusEvent(
          direction: ViewFocusDirection.forward,
          viewId: 1,
          state: ViewFocusState.focused));
      expect(controller.viewFocusChangedCalled, isTrue);

      controller.handleStatusBarTap();
      expect(controller.statusBarTapCalled, isTrue);
    });

    test('Should trigger all navigation observer methods', () async {
      expect(await controller.didPopRoute(), isTrue);
      expect(controller.popRouteCalled, isTrue);

      expect(await controller.didPushRoute('test'), isTrue);
      expect(controller.pushRouteCalled, isTrue);

      expect(
          await controller
              .didPushRouteInformation(RouteInformation(uri: Uri.parse('/'))),
          isTrue);
      expect(controller.pushRouteInfoCalled, isTrue);

      expect(await controller.didRequestAppExit(), AppExitResponse.exit);
      expect(controller.requestAppExitCalled, isTrue);
    });
  });
}
