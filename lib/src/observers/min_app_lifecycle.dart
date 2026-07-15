import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A mixin class that simplifies observing Flutter application lifecycle events,
/// system updates, and navigation callbacks.
///
/// This acts as a wrapper around [WidgetsBindingObserver], allowing classes to
/// react to lifecycle changes without having to manually register or implement
/// all observer methods.
///
/// Subclasses can mix in or extend this class and override only the specific
/// callbacks they require.
///
/// ### Example
///
/// ```dart
/// class HomeController extends MinNotifier with AppLifecycleMixin {
///   @override
///   void onResumed() {
///     debugPrint('App returned to the foreground');
///   }
///
///   @override
///   void onPaused() {
///     debugPrint('App went to the background');
///   }
/// }
/// ```
mixin class AppLifecycleMixin implements WidgetsBindingObserver {
  // ---------------------------------------------------------------------------
  // App Lifecycle Callbacks
  // ---------------------------------------------------------------------------

  /// Called when the application is visible and responding to user input.
  ///
  /// Corresponds to [AppLifecycleState.resumed].
  void onResumed() {}

  /// Called when the application is in an inactive state and is not receiving input.
  ///
  /// This happens, for example, during a phone call or when a system dialog is open.
  /// Corresponds to [AppLifecycleState.inactive].
  void onInactive() {}

  /// Called when the application is not currently visible to the user and is
  /// running in the background.
  ///
  /// Corresponds to [AppLifecycleState.paused].
  void onPaused() {}

  /// Called when all views of the application have been hidden.
  ///
  /// Corresponds to [AppLifecycleState.hidden].
  void onHidden() {}

  /// Called when the application is still hosted on a Flutter engine but is
  /// detached from any host views.
  ///
  /// Corresponds to [AppLifecycleState.detached].
  void onDetached() {}

  /// Called whenever the application's lifecycle state changes.
  ///
  /// Provides the raw [AppLifecycleState] before routing to specific callbacks.
  void onLifecycleChanged(AppLifecycleState state) {}

  // ---------------------------------------------------------------------------
  // System Events Callbacks
  // ---------------------------------------------------------------------------

  /// Called when the system is running low on available memory.
  void onMemoryPressure() {}

  /// Called when the platform's active brightness setting changes (e.g., toggling dark mode).
  void onPlatformBrightnessChanged() {}

  /// Called when the system's preferred locales are updated.
  void onLocalesChanged(List<Locale>? locales) {}

  /// Called when the active accessibility features of the platform are changed.
  void onAccessibilityFeaturesChanged() {}

  /// Called when the application's physical metrics (like screen size or orientation) change.
  void onMetricsChanged() {}

  /// Called when a view's focus state transitions.
  void onViewFocusChanged(ViewFocusEvent event) {}

  /// Called when the platform's text scale factor changes (e.g., user changes font size settings).
  void onChangeTextScaleFactor() {}

  /// Called when the user taps the device status bar (primarily on iOS devices).
  void onHandleStatusBarTap() {}

  // ---------------------------------------------------------------------------
  // Navigation Events Callbacks
  // ---------------------------------------------------------------------------

  /// Called when the system requests to pop the current route.
  ///
  /// Returns `true` if the route pop request was handled internally,
  /// or `false` to let the system handle it.
  Future<bool> onPopRoute() async => false;

  /// Called when the system requests to push a new route path.
  ///
  /// Returns `true` if the request was handled, or `false` otherwise.
  Future<bool> onPushRoute(String route) async => false;

  /// Called when the system pushes new route information (e.g., via deep linking).
  ///
  /// Returns `true` if the route information was successfully handled.
  Future<bool> onPushRouteInformation(
    RouteInformation routeInformation,
  ) async =>
      false;

  /// Called when the platform requests to terminate the application.
  ///
  /// Returns an `AppExitResponse` indicating whether the application should
  /// proceed to exit or cancel the request.
  Future<AppExitResponse> onRequestAppExit() async {
    return AppExitResponse.exit;
  }

  // ---------------------------------------------------------------------------
  // Predictive Back Gesture Callbacks (Android)
  // ---------------------------------------------------------------------------

  /// Called when a predictive back gesture is initiated.
  ///
  /// Returns `true` if this mixin will handle the gesture lifecycle.
  bool onStartBackGesture(PredictiveBackEvent event) => false;

  /// Called sequentially as the predictive back gesture updates its progress.
  void onUpdateBackGestureProgress(
    PredictiveBackEvent event,
  ) {}

  /// Called when the predictive back gesture is fully committed (user completed the swipe).
  void onCommitBackGesture() {}

  /// Called when the predictive back gesture is canceled.
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
    onHandleStatusBarTap();
  }
}
