import 'package:flutter/foundation.dart';

/// A robust, lightweight base class for reactive state management that extends [ChangeNotifier].
///
/// `MinNotifier` retains all native features, properties, and contract behaviors of Flutter's
/// standard [ChangeNotifier], but elevates the developer experience by introducing built-in
/// lifecycle hooks ([onInit], [onReady]) and dynamic mutation utilities ([update]).
///
/// This structure is specifically designed to keep your presentation layer (Views/Pages) entirely
/// **Stateless**, encapsulating asynchronous setup operations, side-effects, and initial data fetching
/// cleanly within the controller layer. (Controller, ViewModel etc)
///
/// Example usage:
/// ```dart
/// class HomeViewModel extends MinNotifier {
///   final UserService _service = UserService();
///   final User user = User();
///   bool isLoading = true;
///
///   @override
///   void onInit() {
///     // Triggers instantly on creation. Ideal for immediate data fetching
///     // without ever needing a StatefulWidget's initState on the page.
///     fetchUserData();
///   }
///
///   Future<void> fetchUserData() async {
///     final data = await _service.getProfile();
///     update(user, (u) => u.copyWith(data));
///     isLoading = false;
///     notifyListeners();
///   }
/// }
/// ```
abstract class MinNotifier extends ChangeNotifier {
  /// Triggered automatically as soon as this controller instance is instantiated in memory.
  ///
  /// Use this hook to perform early initializations, fire immediate API calls, or register
  /// stream listeners. This replaces the traditional requirement of using a `StatefulWidget`
  /// along with its `initState` method just to prepare initial screen states.
  void onInit() {}

  /// Triggered immediately after the screen draws its very first frame.
  ///
  /// This lifecycle hook is executed safely post-frame via `addPostFrameCallback`. It is perfect
  /// for operations that depend on an active interface layout context, such as displaying native
  /// dialogs, snackbars, routing overlays, or starting fine-tuned UI animations.
  void onReady() {}

  /// Safely mutates internal properties of a complex or mutable [target] object
  /// and automatically triggers a UI notification to the widget tree.
  ///
  /// This utility abstracts the boilerplates of altering deep data structures, ensuring
  /// `notifyListeners()` is systematically executed immediately after the execution of the [action].
  ///
  /// Example usage:
  /// ```dart
  /// update(userModel, (user) {
  ///   user.name = 'John Doe';
  ///   user.age = 30;
  /// }); // Rebuilds dependent widgets automatically!
  /// ```
  void update<T>(T target, void Function(T) action) {
    action(target);
    notifyListeners();
  }
}
