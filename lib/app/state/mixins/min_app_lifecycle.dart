import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Base observer that provides optional callbacks for Flutter application
/// lifecycle events.
///
/// Extend this class and override only the callbacks you need.
///
/// Example:
///
/// ```dart
/// class HomeController extends MinNotifier
///     with AppLifecycleMixin {
///
///   @override
///   void onResumed() {
///     print('App resumed');
///   }
///
///   @override
///   void onPaused() {
///     print('App paused');
///   }
/// }
/// ```
mixin class AppLifecycleMixin implements WidgetsBindingObserver {
  // ---------------------------------------------------------------------------
  // App Lifecycle
  // ---------------------------------------------------------------------------

  void onResumed() {}

  void onInactive() {}

  void onPaused() {}

  void onHidden() {}

  void onDetached() {}

  void onLifecycleChanged(AppLifecycleState state) {}

  // ---------------------------------------------------------------------------
  // System Events
  // ---------------------------------------------------------------------------

  void onMemoryPressure() {}

  void onPlatformBrightnessChanged() {}

  void onLocalesChanged(List<Locale>? locales) {}

  void onAccessibilityFeaturesChanged() {}

  void onMetricsChanged() {}

  void onViewFocusChanged(ViewFocusEvent event) {}

  void onChangeTextScaleFactor() {}

  // ---------------------------------------------------------------------------
  // Navigation Events
  // ---------------------------------------------------------------------------

  Future<bool> onPopRoute() async => false;

  Future<bool> onPushRoute(String route) async => false;

  Future<bool> onPushRouteInformation(
    RouteInformation routeInformation,
  ) async =>
      false;

  Future<AppExitResponse> onRequestAppExit() async {
    return AppExitResponse.exit;
  }

  // ---------------------------------------------------------------------------
  // Predictive Back Gesture (Android)
  // ---------------------------------------------------------------------------

  bool onStartBackGesture(PredictiveBackEvent event) => false;

  void onUpdateBackGestureProgress(
    PredictiveBackEvent event,
  ) {}

  void onCommitBackGesture() {}

  void onCancelBackGesture() {}

  // ---------------------------------------------------------------------------
  // WidgetsBindingObserver Implementation
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onLifecycleChanged(state);

    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;

      case AppLifecycleState.inactive:
        onInactive();
        break;

      case AppLifecycleState.paused:
        onPaused();
        break;

      case AppLifecycleState.hidden:
        onHidden();
        break;

      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  @override
  void didHaveMemoryPressure() {
    onMemoryPressure();
  }

  @override
  void didChangePlatformBrightness() {
    onPlatformBrightnessChanged();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    onLocalesChanged(locales);
  }

  @override
  void didChangeAccessibilityFeatures() {
    onAccessibilityFeaturesChanged();
  }

  @override
  void didChangeMetrics() {
    onMetricsChanged();
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    onViewFocusChanged(event);
  }

  @override
  Future<bool> didPopRoute() {
    return onPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    return onPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(
    RouteInformation routeInformation,
  ) {
    return onPushRouteInformation(routeInformation);
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    return onRequestAppExit();
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent event) {
    return onStartBackGesture(event);
  }

  @override
  void handleUpdateBackGestureProgress(
    PredictiveBackEvent event,
  ) {
    onUpdateBackGestureProgress(event);
  }

  @override
  void handleCommitBackGesture() {
    onCommitBackGesture();
  }

  @override
  void handleCancelBackGesture() {
    onCancelBackGesture();
  }

  @override
  void didChangeTextScaleFactor() {
    onChangeTextScaleFactor();
  }

  @override
  void handleStatusBarTap() {
    // TODO: implement handleStatusBarTap
  }
}
