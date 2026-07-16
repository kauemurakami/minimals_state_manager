import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// A concrete implementation of [AppLifecycleMixin] used for testing purposes.
///
/// This class tracks which lifecycle methods have been invoked, allowing
/// verification that the mixin correctly delegates calls from [WidgetsBindingObserver].
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

  // Back gesture tracking
  bool startBackGestureCalled = false;
  bool updateBackGestureCalled = false;
  bool commitBackGestureCalled = false;
  bool cancelBackGestureCalled = false;

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
  bool onStartBackGesture(PredictiveBackEvent e) {
    startBackGestureCalled = true;
    return true;
  }

  @override
  void onUpdateBackGestureProgress(PredictiveBackEvent e) {
    updateBackGestureCalled = true;
  }

  @override
  void onCommitBackGesture() {
    commitBackGestureCalled = true;
  }

  @override
  void onCancelBackGesture() {
    cancelBackGestureCalled = true;
  }

  @override
  Future<bool> onPopRoute() async {
    popRouteCalled = true;
    return true;
  }

  @override
  Future<bool> onPushRoute(String r) async {
    pushRouteCalled = true;
    return true;
  }

  @override
  Future<bool> onPushRouteInformation(RouteInformation i) async {
    pushRouteInfoCalled = true;
    return true;
  }

  @override
  Future<AppExitResponse> onRequestAppExit() async {
    requestAppExitCalled = true;
    return AppExitResponse.exit;
  }
}

class _DefaultLifecycleObserver with AppLifecycleMixin {}

class _TestLifecycleObserver with AppLifecycleMixin {}

void main() {
  group('AppLifecycleMixin Coverage Tests', () {
    late TestLifecycleController controller;

    setUp(() {
      controller = TestLifecycleController();
    });

    test('Should trigger default mixin implementations', () {
      final defaultMixin = _DefaultLifecycleObserver();

      expect(
          defaultMixin.onStartBackGesture(PredictiveBackEvent.fromMap(const {
            'touchOffset': [0.0, 0.0],
            'progress': 0.0,
            'swipeEdge': 0,
          })),
          isFalse); // O padrão retorna false

      defaultMixin
          .onUpdateBackGestureProgress(PredictiveBackEvent.fromMap(const {
        'touchOffset': [0.0, 0.0],
        'progress': 0.0,
        'swipeEdge': 0,
      }));

      defaultMixin.onCommitBackGesture();
      defaultMixin.onCancelBackGesture();
    });

    test('Should trigger all lifecycle state changes and switch branches', () {
      final states = [
        AppLifecycleState.resumed,
        AppLifecycleState.inactive,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.detached,
      ];

      for (final state in states) {
        controller.didChangeAppLifecycleState(state);
      }

      expect(controller.resumedCalled, isTrue);
      expect(controller.inactiveCalled, isTrue);
      expect(controller.pausedCalled, isTrue);
      expect(controller.hiddenCalled, isTrue);
      expect(controller.detachedCalled, isTrue);
      expect(controller.lifecycleChangedCalled, isTrue);
    });

    test('Should trigger all system observer methods', () {
      controller.didHaveMemoryPressure();
      controller.didChangePlatformBrightness();
      controller.didChangeLocales(null);
      controller.didChangeAccessibilityFeatures();
      controller.didChangeMetrics();
      controller.didChangeTextScaleFactor();
      controller.handleStatusBarTap();
      controller.didChangeViewFocus(const ViewFocusEvent(
          direction: ViewFocusDirection.forward,
          viewId: 1,
          state: ViewFocusState.focused));

      expect(controller.memoryPressureCalled, isTrue);
      expect(controller.platformBrightnessCalled, isTrue);
      expect(controller.localesChangedCalled, isTrue);
      expect(controller.accessibilityChangedCalled, isTrue);
      expect(controller.metricsChangedCalled, isTrue);
      expect(controller.textScaleFactorCalled, isTrue);
      expect(controller.statusBarTapCalled, isTrue);
      expect(controller.viewFocusChangedCalled, isTrue);
    });

    test('Should trigger all predictive back gesture methods', () {
      final event = PredictiveBackEvent.fromMap(const {
        'touchOffset': [0.0, 0.0],
        'progress': 0.0,
        'swipeEdge': 0,
      });

      expect(controller.handleStartBackGesture(event), isTrue);
      expect(controller.startBackGestureCalled, isTrue);

      controller.handleUpdateBackGestureProgress(event);
      expect(controller.updateBackGestureCalled, isTrue);

      controller.handleCommitBackGesture();
      expect(controller.commitBackGestureCalled, isTrue);

      controller.handleCancelBackGesture();
      expect(controller.cancelBackGestureCalled, isTrue);
    });

    group('AppLifecycleMixin Lifecycle & Routing', () {
      /// {@template min_app_lifecycle_test.custom_implementation}
      /// **Test Target:** Custom `AppLifecycleMixin` Implementation
      ///
      /// **Objective:** Verifies that a class overriding `AppLifecycleMixin`
      /// methods correctly executes the custom logic provided by the controller.
      /// {@endtemplate}
      test('Should trigger all navigation observer methods', () async {
        // Assert: Verify that the overridden methods in 'controller' are called
        // and return the expected values.
        expect(await controller.didPopRoute(), isTrue);
        expect(controller.popRouteCalled, isTrue);

        expect(await controller.didPushRoute('test'), isTrue);
        expect(controller.pushRouteCalled, isTrue);

        expect(
          await controller.didPushRouteInformation(
            RouteInformation(uri: Uri.parse('/')),
          ),
          isTrue,
        );
        expect(controller.pushRouteInfoCalled, isTrue);

        expect(await controller.didRequestAppExit(), AppExitResponse.exit);
        expect(controller.requestAppExitCalled, isTrue);
      });

      /// {@template min_app_lifecycle_test.default_implementation}
      /// **Test Target:** `AppLifecycleMixin` Default Fallback
      ///
      /// **Objective:** Verifies that when a class uses [AppLifecycleMixin] without
      /// overriding its methods, it correctly returns the framework-defined
      /// default values for route handling and app exit requests.
      ///
      /// This test specifically covers the lines in the mixin that provide
      /// default async implementations.
      /// {@endtemplate}
      test(
          'Should return default values when no custom implementation is provided',
          () async {
        // Arrange: Instantiate the concrete helper class that uses the mixin
        final observer = _TestLifecycleObserver();

        // Act & Assert: Verify default route pop handling (returns false)
        expect(await observer.onPopRoute(), isFalse);

        // Act & Assert: Verify default route push handling (returns false)
        expect(await observer.onPushRoute('/test'), isFalse);

        // Act & Assert: Verify default route information handling (returns false)
        expect(
            await observer
                .onPushRouteInformation(RouteInformation(uri: Uri.parse('/'))),
            isFalse);

        // Act & Assert: Verify default app exit behavior (returns AppExitResponse.exit)
        expect(await observer.onRequestAppExit(), AppExitResponse.exit);
      });
    });

    /// {@template min_app_lifecycle_test.constructor}
    /// **Test Target:** `AppLifecycleMixin` Constructor
    ///
    /// **Objective:** Instantiates a class using the mixin to ensure the
    /// constructor is covered by the test suite.
    /// {@endtemplate}
    test('Should instantiate AppLifecycleMixin via concrete class', () {
      final observer = _TestLifecycleObserver();
      expect(observer, isNotNull);
    });
  });
}
